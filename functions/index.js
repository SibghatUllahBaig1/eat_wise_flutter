/* ─────────────────────────────────────────────────────────────────────────────
   EatWise – Firebase Cloud Functions
   Server-side push notification engine (FCM + Firestore notification history)
   ───────────────────────────────────────────────────────────────────────────── */

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// ─────────────────────────────────────────────────────────────────────────────
// Shared helper – send an FCM push AND persist the notification in Firestore
// ─────────────────────────────────────────────────────────────────────────────
/**
 * Sends a push notification via FCM and saves a copy to the user's
 * notifications sub-collection in Firestore.
 *
 * @param {string}  userId   - Firestore user document ID
 * @param {string|null} fcmToken - User's FCM registration token (may be null)
 * @param {string}  type     - Notification type key (e.g. 'subscription_renewal')
 * @param {string}  title    - Push title
 * @param {string}  body     - Push body
 * @param {Object}  [data]   - Optional extra key-value data for the push payload
 */
async function sendPushAndStore(userId, fcmToken, type, title, body, data = {}) {
  const db = admin.firestore();

  // 1. Persist notification to Firestore (always, even without a valid token)
  await db.collection('users').doc(userId).collection('notifications').add({
    type,
    title,
    body,
    data,
    read: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // 2. Send FCM push only when we have a valid token
  if (!fcmToken) {
    console.log(`[${type}] No FCM token for user ${userId}; notification stored only.`);
    return;
  }

  try {
    await admin.messaging().send({
      token: fcmToken,
      notification: {title, body},
      data: {...data, type},
      android: {
        priority: 'high',
        notification: {
          channelId: 'eatwise_notifications',
          sound: 'default',
          clickAction: 'FLUTTER_NOTIFICATION_CLICK',
        },
      },
      apns: {
        payload: {aps: {sound: 'default', badge: 1}},
      },
    });
    console.log(`[${type}] Push sent to user ${userId}`);
  } catch (err) {
    // Token may be stale/invalid – log but don't crash the loop
    console.error(`[${type}] FCM send failed for user ${userId}:`, err.message);
  }
}

/**
 * Fetch the FCM token for a user document.
 * Returns null if not present.
 */
function getFcmToken(userData) {
  return userData && userData.fcmToken ? userData.fcmToken : null;
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Subscription Renewal Reminder  (daily 9 AM UTC)
//    Fires when renewal is exactly 3 days away (premium users).
// ─────────────────────────────────────────────────────────────────────────────
exports.sendSubscriptionRenewalReminders = functions.pubsub
    .schedule('0 9 * * *')
    .timeZone('UTC')
    .onRun(async (_context) => {
      const db = admin.firestore();
      const now = new Date();

      try {
        const usersSnap = await db.collection('users').get();

        for (const userDoc of usersSnap.docs) {
          const userId = userDoc.id;
          const userData = userDoc.data();

          // Get subscription data
          const subDoc = await db
              .collection('users').doc(userId)
              .collection('subscription').doc('current')
              .get();

          if (!subDoc.exists) continue;
          const sub = subDoc.data();
          if (sub.status !== 'active') continue;

          const renewalDate = sub.renewalDate?.toDate();
          if (!renewalDate) continue;

          const daysDiff = Math.round((renewalDate - now) / (24 * 60 * 60 * 1000));

          if (daysDiff === 3) {
            await sendPushAndStore(
                userId,
                getFcmToken(userData),
                'subscription_renewal',
                '📅 Subscription Renewing Soon',
                `Your EatWise Premium subscription renews in 3 days. Make sure your payment details are up to date!`,
                {daysLeft: '3'},
            );
          } else if (daysDiff === 1) {
            await sendPushAndStore(
                userId,
                getFcmToken(userData),
                'subscription_renewal',
                '⏰ Subscription Renews Tomorrow',
                `Your EatWise Premium subscription renews tomorrow. Review your payment details so your access continues without interruption.`,
                {daysLeft: '1'},
            );
          }
        }
      } catch (err) {
        console.error('sendSubscriptionRenewalReminders error:', err);
      }
      return null;
    });

// ─────────────────────────────────────────────────────────────────────────────
// 2. Upgrade Prompt  (every Monday 10 AM UTC)
//    Targets free/standard tier users to encourage upgrading to Premium.
// ─────────────────────────────────────────────────────────────────────────────
exports.sendUpgradePrompts = functions.pubsub
    .schedule('0 10 * * 1')
    .timeZone('UTC')
    .onRun(async (_context) => {
      const db = admin.firestore();

      // Rotating upgrade messages to avoid repetition week after week
      const upgradeMessages = [
        {
          title: '🌟 Unlock Your Full Potential',
          body: 'Upgrade to EatWise Premium for AI-powered meal analysis, advanced analytics, and access to our full recipe library.',
        },
        {
          title: '🚀 Take Your Nutrition to the Next Level',
          body: 'Unlock AI-powered meal analysis, advanced analytics, and personalized macro tracking with EatWise Premium.',
        },
        {
          title: '💪 Premium Features Await You',
          body: 'Get deeper insights into your health trends, custom meal plans, and advanced recipes — only in EatWise Premium.',
        },
      ];

      const weekOfYear = Math.floor(Date.now() / (7 * 24 * 60 * 60 * 1000));
      const msg = upgradeMessages[weekOfYear % upgradeMessages.length];

      try {
        const usersSnap = await db.collection('users').get();

        for (const userDoc of usersSnap.docs) {
          const userId = userDoc.id;
          const userData = userDoc.data();

          // Skip users that already have an active premium subscription
          const subDoc = await db
              .collection('users').doc(userId)
              .collection('subscription').doc('current')
              .get();

          if (subDoc.exists) {
            const sub = subDoc.data();
            if (sub.status === 'active' && sub.tier === 'premium') continue;
          }

          await sendPushAndStore(
              userId,
              getFcmToken(userData),
              'upgrade_prompt',
              msg.title,
              msg.body,
          );
        }
      } catch (err) {
        console.error('sendUpgradePrompts error:', err);
      }
      return null;
    });

// ─────────────────────────────────────────────────────────────────────────────
// 3. Monthly Encouragement  (1st of month, 9 AM UTC)
//    Analyses last 30 days of weight & meal data to detect evolution
//    (progress toward goal) or involution (regression), then sends a
//    personalised encouraging message.
// ─────────────────────────────────────────────────────────────────────────────
exports.sendMonthlyEncouragement = functions.pubsub
    .schedule('0 9 1 * *')
    .timeZone('UTC')
    .onRun(async (_context) => {
      const db = admin.firestore();

      const now = new Date();
      const thirtyDaysAgo = new Date(now.getTime() - 30 * 24 * 60 * 60 * 1000);

      try {
        const usersSnap = await db.collection('users').get();

        for (const userDoc of usersSnap.docs) {
          const userId = userDoc.id;
          const userData = userDoc.data();

          // ── Meal logging consistency ─────────────────────────────────────
          const mealsSnap = await db
              .collection('users').doc(userId)
              .collection('meals')
              .where('createdAt', '>=', thirtyDaysAgo)
              .get();

          const daysLogged = new Set();
          mealsSnap.forEach((doc) => {
            const ts = doc.data().createdAt?.toDate() || doc.data().date?.toDate();
            if (ts) daysLogged.add(ts.toDateString());
          });
          const daysLoggedCount = daysLogged.size;
          const consistencyPct = Math.round((daysLoggedCount / 30) * 100);

          // ── Weight evolution ─────────────────────────────────────────────
          const weightSnap = await db
              .collection('users').doc(userId)
              .collection('weight_tracker')
              .where('createdAt', '>=', thirtyDaysAgo)
              .orderBy('createdAt', 'asc')
              .get();

          let weightDelta = null;
          if (weightSnap.size >= 2) {
            const first = weightSnap.docs[0].data().weight;
            const last = weightSnap.docs[weightSnap.size - 1].data().weight;
            if (typeof first === 'number' && typeof last === 'number') {
              weightDelta = last - first; // negative = lost weight
            }
          }

          // Determine user's goal direction (from userData or onboarding)
          const goal = userData.onboardingAnswers?.goal || userData.goal || '';
          const wantsToLose = /los|deficit|cut/i.test(goal);
          const wantsToGain = /gain|bulk|muscle/i.test(goal);

          // Skip users with no meaningful activity data this period.
          if (daysLoggedCount === 0 && weightDelta === null) continue;

          // Decide: evolution (positive progress) or involution (regression)
          let isEvolution = true;
          let weightSummary = '';
          if (weightDelta !== null) {
            const deltaKg = Math.abs(weightDelta).toFixed(1);
            if (wantsToLose) {
              isEvolution = weightDelta <= 0;
              weightSummary = weightDelta <= 0
                ? `You lost ${deltaKg} kg over the past 30 days — outstanding!`
                : `You gained ${deltaKg} kg over the past 30 days — let's refocus together.`;
            } else if (wantsToGain) {
              isEvolution = weightDelta >= 0;
              weightSummary = weightDelta >= 0
                ? `You gained ${deltaKg} kg over the past 30 days — great progress toward your goal!`
                : `You lost ${deltaKg} kg over the past 30 days — let's adjust your nutrition plan.`;
            } else {
              isEvolution = Math.abs(weightDelta) < 1;
              weightSummary = Math.abs(weightDelta) < 1
                ? 'Your weight stayed stable — well maintained!'
                : `Your weight shifted by ${deltaKg} kg. Let's review your plan.`;
            }
          } else {
            // No weight data — base the tone on meal-logging consistency only.
            isEvolution = consistencyPct >= 50;
          }

          const loggingSummary =
            `you logged meals on ${daysLoggedCount} of 30 days (${consistencyPct}% consistency).`;
          const weightLine = weightSummary ? ` ${weightSummary}` : '';

          // Build personalised message
          let title; let body;
          if (isEvolution && consistencyPct >= 50) {
            title = '🎉 Amazing Progress This Month!';
            body = `Over the past 30 days, ${loggingSummary}${weightLine} Keep it up — your hard work is paying off!`;
          } else if (isEvolution) {
            title = '📈 Good Start — Room to Grow';
            body = `You logged meals on ${daysLoggedCount} of 30 days (${consistencyPct}% consistency).${weightLine} Try logging a little more often to get the most out of EatWise.`;
          } else if (consistencyPct >= 50) {
            title = '💪 Keep Logging — We Can Adjust';
            body = `You logged meals on ${daysLoggedCount} of 30 days (${consistencyPct}% consistency).${weightLine} Your consistency is strong — small plan tweaks can help you get back on track.`;
          } else {
            title = '💪 Let\'s Make This Month Even Better!';
            body = `Over the past 30 days, ${loggingSummary}${weightLine} Small, steady changes add up — we're here to support you!`;
          }

          await sendPushAndStore(
              userId,
              getFcmToken(userData),
              'monthly_encouragement',
              title,
              body,
              {daysLogged: String(daysLoggedCount), consistencyPct: String(consistencyPct)},
          );
        }
      } catch (err) {
        console.error('sendMonthlyEncouragement error:', err);
      }
      return null;
    });

// ─────────────────────────────────────────────────────────────────────────────
// 4. Inactivity Reminder  (runs every hour; respects user's IANA timezone)
//    If it's 6 PM in the user's local timezone and they haven't logged a
//    single meal today, send a gentle reminder.
// ─────────────────────────────────────────────────────────────────────────────
exports.sendInactivityReminders = functions.pubsub
    .schedule('0 * * * *') // every hour at :00
    .timeZone('UTC')
    .onRun(async (_context) => {
      const db = admin.firestore();

      try {
        const usersSnap = await db.collection('users').get();
        const nowUtc = new Date();

        for (const userDoc of usersSnap.docs) {
          const userId = userDoc.id;
          const userData = userDoc.data();

          // ── Determine user's local hour ──────────────────────────────────
          // Timezone stored by MealReminderService at settings/meal_reminders
          const reminderDoc = await db
              .collection('users').doc(userId)
              .collection('settings').doc('meal_reminders')
              .get();

          const tz = reminderDoc.exists
            ? (reminderDoc.data().timezone || 'UTC')
            : 'UTC';

          let localHour;
          try {
            const formatter = new Intl.DateTimeFormat('en-US', {
              timeZone: tz,
              hour: 'numeric',
              hour12: false,
            });
            localHour = parseInt(formatter.format(nowUtc), 10);
          } catch (_) {
            localHour = nowUtc.getUTCHours();
          }

          // Only fire at 6 PM local time
          if (localHour !== 18) continue;

          // ── Check if already sent an inactivity reminder today ────────────
          const startOfToday = new Date(nowUtc);
          try {
            // Get midnight in user's timezone
            const dateParts = new Intl.DateTimeFormat('en-CA', {
              timeZone: tz,
              year: 'numeric', month: '2-digit', day: '2-digit',
            }).formatToParts(nowUtc);
            const y = dateParts.find((p) => p.type === 'year').value;
            const m = dateParts.find((p) => p.type === 'month').value;
            const d = dateParts.find((p) => p.type === 'day').value;
            startOfToday.setTime(new Date(`${y}-${m}-${d}T00:00:00Z`).getTime());
          } catch (_) {
            startOfToday.setUTCHours(0, 0, 0, 0);
          }

          // Check if we already sent one today
          const alreadySentSnap = await db
              .collection('users').doc(userId)
              .collection('notifications')
              .where('type', '==', 'inactivity_reminder')
              .where('createdAt', '>=', startOfToday)
              .limit(1)
              .get();

          if (!alreadySentSnap.empty) continue;

          // ── Check if user has logged any meals today ──────────────────────
          const mealsSnap = await db
              .collection('users').doc(userId)
              .collection('meals')
              .where('createdAt', '>=', startOfToday)
              .limit(1)
              .get();

          // Also check by 'date' field in case createdAt is missing
          const mealsByDateSnap = mealsSnap.empty
            ? await db.collection('users').doc(userId).collection('meals')
                .where('date', '>=', admin.firestore.Timestamp.fromDate(startOfToday))
                .limit(1)
                .get()
            : mealsSnap;

          if (!mealsByDateSnap.empty) continue; // Already logged today

          const inactivityMessages = [
            {
              title: '🍽️ Don\'t Forget to Log Your Meals!',
              body: 'You haven\'t tracked any food today. Log your meals now to stay on top of your nutrition goals!',
            },
            {
              title: '📊 Your Nutrition Tracker is Waiting',
              body: 'It\'s 6 PM and no meals logged yet. Take a moment to add what you\'ve eaten — it only takes seconds!',
            },
            {
              title: '💚 Check In with Your Health',
              body: 'A day of tracking is better than none! Log your meals before bed to stay on top of your goals.',
            },
          ];

          const dayOfWeek = nowUtc.getUTCDay();
          const msg = inactivityMessages[dayOfWeek % inactivityMessages.length];

          await sendPushAndStore(
              userId,
              getFcmToken(userData),
              'inactivity_reminder',
              msg.title,
              msg.body,
          );
        }
      } catch (err) {
        console.error('sendInactivityReminders error:', err);
      }
      return null;
    });

// ─────────────────────────────────────────────────────────────────────────────
// 5. Test Notification  (HTTPS Callable)
//    Call via Firebase SDK: FirebaseFunctions.instance.httpsCallable('sendTestNotification').call()
//    Or via REST: POST https://<region>-<project>.cloudfunctions.net/sendTestNotification
//    with body: {"data":{}}
//    Sends a test push to ALL users that have an FCM token.
// ─────────────────────────────────────────────────────────────────────────────
exports.sendTestNotification = functions.https.onCall(async (_data, _context) => {
  const db = admin.firestore();

  try {
    const usersSnap = await db.collection('users').get();
    const results = {sent: 0, stored: 0, skipped: 0};

    for (const userDoc of usersSnap.docs) {
      const userId = userDoc.id;
      const userData = userDoc.data();
      const token = getFcmToken(userData);

      await sendPushAndStore(
          userId,
          token,
          'test_notification',
          '🔔 Test Notification',
          'This is a test push from EatWise server. Your notifications are working perfectly!',
          {source: 'manual_test'},
      );

      results.stored++;
      if (token) results.sent++;
      else results.skipped++;
    }

    console.log('Test notification results:', results);
    return {success: true, ...results};
  } catch (err) {
    console.error('sendTestNotification error:', err);
    throw new functions.https.HttpsError('internal', err.message);
  }
});

// ─────────────────────────────────────────────────────────────────────────────
// Shared helper – tracker reminder logic
// ─────────────────────────────────────────────────────────────────────────────

/**
 * Converts a 12-hour time (hour string, ampm string) to a 24-hour integer.
 * e.g. ("12", "AM") → 0, ("12", "PM") → 12, ("8", "PM") → 20
 */
function to24Hour(hourStr, ampm) {
  const h = parseInt(hourStr, 10);
  if (isNaN(h)) return -1;
  if (ampm === 'AM') return h === 12 ? 0 : h;
  return h === 12 ? 12 : h + 12;
}

/** Returns the start of the current day in the user's timezone as a JS Date. */
function getStartOfDayInTz(nowUtc, tz) {
  try {
    const parts = new Intl.DateTimeFormat('en-CA', {
      timeZone: tz, year: 'numeric', month: '2-digit', day: '2-digit',
    }).formatToParts(nowUtc);
    const y = parts.find((p) => p.type === 'year').value;
    const m = parts.find((p) => p.type === 'month').value;
    const d = parts.find((p) => p.type === 'day').value;
    return new Date(`${y}-${m}-${d}T00:00:00Z`);
  } catch (_) {
    const sod = new Date(nowUtc);
    sod.setUTCHours(0, 0, 0, 0);
    return sod;
  }
}

/** Returns the user's local hour (0-23) in the given IANA timezone. */
function getLocalHour(nowUtc, tz) {
  try {
    return parseInt(
        new Intl.DateTimeFormat('en-US', {
          timeZone: tz, hour: 'numeric', hour12: false,
        }).format(nowUtc),
        10,
    );
  } catch (_) {
    return nowUtc.getUTCHours();
  }
}

/** Returns the full day name ("Monday", "Tuesday", …) in the user's timezone. */
function getLocalDayName(nowUtc, tz) {
  try {
    return new Intl.DateTimeFormat('en-US', {
      timeZone: tz, weekday: 'long',
    }).format(nowUtc);
  } catch (_) {
    const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    return days[nowUtc.getUTCDay()];
  }
}

/**
 * Core routine for hourly tracker reminders.
 * Reads `users/{uid}/settings/tracker_reminders.<trackerKey>` and fires
 * an FCM push if:
 *   - reminder is enabled
 *   - today is one of the user's chosen repeat days
 *   - the current local hour matches the configured reminder hour
 *   - no reminder of this type has been sent today yet
 *
 * @param {FirebaseFirestore.Firestore} db
 * @param {string} trackerKey   - 'water' | 'step' | 'weight'
 * @param {string} notifType    - value stored in notifications.type
 * @param {Array}  messages     - rotating array of {title, body} objects
 */
async function processTrackerReminders(db, trackerKey, notifType, messages) {
  const usersSnap = await db.collection('users').get();
  const nowUtc = new Date();

  for (const userDoc of usersSnap.docs) {
    try {
      const userId = userDoc.id;
      const userData = userDoc.data();

      // ── Load tracker reminder settings ──────────────────────────────────
      const settingsDoc = await db
          .collection('users').doc(userId)
          .collection('settings').doc('tracker_reminders')
          .get();

      if (!settingsDoc.exists) continue;
      const settings = settingsDoc.data();
      const trackerSettings = settings[trackerKey];
      if (!trackerSettings || !trackerSettings.enabled) continue;

      const tz = settings.timezone || 'UTC';
      const {hour: hourStr, minute: minuteStr, ampm, repeatDays} = trackerSettings;

      // ── Check day of week ───────────────────────────────────────────────
      if (Array.isArray(repeatDays) && repeatDays.length > 0) {
        const todayName = getLocalDayName(nowUtc, tz);
        if (!repeatDays.includes(todayName)) continue;
      }

      // ── Check local hour ────────────────────────────────────────────────
      const reminderHour24 = to24Hour(hourStr, ampm);
      const localHour = getLocalHour(nowUtc, tz);
      if (localHour !== reminderHour24) continue;

      // ── Deduplicate – only one notification per day ─────────────────────
      const startOfDay = getStartOfDayInTz(nowUtc, tz);
      const alreadySentSnap = await db
          .collection('users').doc(userId)
          .collection('notifications')
          .where('type', '==', notifType)
          .where('createdAt', '>=', startOfDay)
          .limit(1)
          .get();
      if (!alreadySentSnap.empty) continue;

      // ── Pick a rotating message and send ────────────────────────────────
      const dayIndex = nowUtc.getUTCDay();
      const msg = messages[dayIndex % messages.length];

      await sendPushAndStore(
          userId,
          getFcmToken(userData),
          notifType,
          msg.title,
          msg.body,
          {trackerKey},
      );
    } catch (userErr) {
      console.error(`[${notifType}] Error processing user ${userDoc.id}:`, userErr.message);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. Water Reminder  (runs every hour; respects user's IANA timezone)
//    Fires at the user's configured reminder time on their chosen repeat days.
// ─────────────────────────────────────────────────────────────────────────────
exports.sendWaterReminders = functions.pubsub
    .schedule('0 * * * *') // every hour at :00
    .timeZone('UTC')
    .onRun(async (_context) => {
      const db = admin.firestore();
      const messages = [
        {
          title: '💧 Time to Hydrate!',
          body: 'Time for a water break — staying hydrated keeps your energy up and supports your nutrition goals.',
        },
        {
          title: '🚰 Drink Up!',
          body: 'A glass of water now can curb cravings, improve focus, and support your nutrition goals. Your body will thank you!',
        },
        {
          title: '💦 Hydration Check',
          body: 'EatWise reminds you: sip by sip you reach your daily water goal. Have a glass now and stay on track!',
        },
        {
          title: '🌊 Water Reminder',
          body: 'Good hydration is the foundation of good health. Take a moment to drink a glass of water right now!',
        },
      ];
      try {
        await processTrackerReminders(db, 'water', 'water_reminder', messages);
      } catch (err) {
        console.error('sendWaterReminders error:', err);
      }
      return null;
    });

// ─────────────────────────────────────────────────────────────────────────────
// 7. Step Counter Reminder  (runs every hour; respects user's IANA timezone)
//    Fires at the user's configured reminder time on their chosen repeat days.
// ─────────────────────────────────────────────────────────────────────────────
exports.sendStepReminders = functions.pubsub
    .schedule('0 * * * *')
    .timeZone('UTC')
    .onRun(async (_context) => {
      const db = admin.firestore();
      const messages = [
        {
          title: '👟 Time to Move!',
          body: 'Get up and take a walk! Every step counts toward your daily goal. A short walk now can boost your mood and burn extra calories.',
        },
        {
          title: '🚶 Step it Up!',
          body: 'Your step goal is waiting. Even a 10-minute walk makes a difference — lace up and get moving!',
        },
        {
          title: '🏃 Walking Reminder',
          body: 'Consistent movement is one of the best things you can do for your health. How many steps have you taken today?',
        },
        {
          title: '⚡ Stay Active!',
          body: 'A quick walk now can help you reach your daily step goal. Stand up, stretch, and get moving!',
        },
      ];
      try {
        await processTrackerReminders(db, 'step', 'step_reminder', messages);
      } catch (err) {
        console.error('sendStepReminders error:', err);
      }
      return null;
    });

// ─────────────────────────────────────────────────────────────────────────────
// 8. Weight Tracker Reminder  (runs every hour; respects user's IANA timezone)
//    Fires at the user's configured reminder time on their chosen repeat days.
// ─────────────────────────────────────────────────────────────────────────────
exports.sendWeightReminders = functions.pubsub
    .schedule('0 * * * *')
    .timeZone('UTC')
    .onRun(async (_context) => {
      const db = admin.firestore();
      const messages = [
        {
          title: '⚖️ Time to Log Your Weight',
          body: 'Step on the scale and record today\'s reading. Consistent tracking is the #1 habit of people who successfully reach their weight goals!',
        },
        {
          title: '⚖️ Weight Check-In',
          body: 'Your weight data tells your progress story. Log today\'s weight in EatWise and watch your trend unfold over time.',
        },
        {
          title: '🎯 Stay on Target',
          body: 'A quick weigh-in keeps you accountable and motivated. Open EatWise and log your weight — every data point matters!',
        },
        {
          title: '💪 Track Your Progress',
          body: 'Logging your weight regularly helps you spot trends over time. Add today\'s reading to keep your progress chart up to date.',
        },
      ];
      try {
        await processTrackerReminders(db, 'weight', 'weight_reminder', messages);
      } catch (err) {
        console.error('sendWeightReminders error:', err);
      }
      return null;
    });

