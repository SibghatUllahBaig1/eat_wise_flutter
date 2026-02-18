const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

/**
 * Scheduled function to send subscription renewal reminders
 * Runs daily at 9 AM UTC
 */
exports.sendSubscriptionRenewalReminders = functions.pubsub
    .schedule('0 9 * * *')
    .timeZone('UTC')
    .onRun(async (context) => {
      const db = admin.firestore();
      const now = new Date();
      const threeDaysFromNow = new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000);

      try {
        // Get all users with active subscriptions
        const usersSnapshot = await db.collection('users').get();

        for (const userDoc of usersSnapshot.docs) {
          const userId = userDoc.id;

          // Check notification preferences
          const prefsDoc = await db
              .collection('users')
              .doc(userId)
              .collection('notificationSettings')
              .doc('preferences')
              .get();

          const prefs = prefsDoc.data() || {};
          if (prefs.subscriptionRenewal !== true) continue;

          // Get subscription data
          const subDoc = await db
              .collection('users')
              .doc(userId)
              .collection('subscription')
              .doc('current')
              .get();

          if (!subDoc.exists) continue;

          const subData = subDoc.data();
          if (subData.status !== 'active') continue;

          const renewalDate = subData.renewalDate?.toDate();
          if (!renewalDate) continue;

          // Check if renewal is in 3 days
          const daysDiff = Math.floor(
              (renewalDate - now) / (24 * 60 * 60 * 1000),
          );

          if (daysDiff === 3) {
            // Store notification trigger in Firestore
            await db
                .collection('users')
                .doc(userId)
                .collection('notifications')
                .add({
                  type: 'subscription_renewal',
                  title: 'Subscription Renewal',
                  body: 'Your subscription will renew in 3 days',
                  createdAt: admin.firestore.FieldValue.serverTimestamp(),
                  read: false,
                });

            console.log(`Renewal reminder queued for user ${userId}`);
          }
        }

        return null;
      } catch (error) {
        console.error('Error sending renewal reminders:', error);
        return null;
      }
    });

/**
 * Scheduled function to send upgrade prompts to Standard users
 * Runs weekly on Monday at 10 AM UTC
 */
exports.sendUpgradePrompts = functions.pubsub
    .schedule('0 10 * * 1')
    .timeZone('UTC')
    .onRun(async (context) => {
      const db = admin.firestore();

      try {
        const usersSnapshot = await db.collection('users').get();

        for (const userDoc of usersSnapshot.docs) {
          const userId = userDoc.id;

          // Check notification preferences
          const prefsDoc = await db
              .collection('users')
              .doc(userId)
              .collection('notificationSettings')
              .doc('preferences')
              .get();

          const prefs = prefsDoc.data() || {};
          if (prefs.upgradePrompt !== true) continue;

          // Get subscription data
          const subDoc = await db
              .collection('users')
              .doc(userId)
              .collection('subscription')
              .doc('current')
              .get();

          if (!subDoc.exists) continue;

          const subData = subDoc.data();
          if (subData.tier !== 'standard') continue;

          // Store notification trigger
          await db
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .add({
                type: 'upgrade_prompt',
                title: 'Upgrade to Premium',
                body: 'Unlock advanced features with Premium subscription',
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                read: false,
              });

          console.log(`Upgrade prompt queued for user ${userId}`);
        }

        return null;
      } catch (error) {
        console.error('Error sending upgrade prompts:', error);
        return null;
      }
    });

/**
 * Scheduled function to send monthly progress reports
 * Runs on the 1st of each month at 9 AM UTC
 */
exports.sendMonthlyProgressReports = functions.pubsub
    .schedule('0 9 1 * *')
    .timeZone('UTC')
    .onRun(async (context) => {
      const db = admin.firestore();

      try {
        const usersSnapshot = await db.collection('users').get();

        for (const userDoc of usersSnapshot.docs) {
          const userId = userDoc.id;

          // Check notification preferences
          const prefsDoc = await db
              .collection('users')
              .doc(userId)
              .collection('notificationSettings')
              .doc('preferences')
              .get();

          const prefs = prefsDoc.data() || {};
          if (prefs.monthlyProgress !== true) continue;

          // Calculate last month's stats
          const now = new Date();
          const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
          const lastMonthEnd = new Date(now.getFullYear(), now.getMonth(), 0);

          // Get meals from last month
          const mealsSnapshot = await db
              .collection('users')
              .doc(userId)
              .collection('meals')
              .where('date', '>=', lastMonth)
              .where('date', '<=', lastMonthEnd)
              .get();

          const daysLogged = new Set();
          mealsSnapshot.forEach((doc) => {
            const date = doc.data().date?.toDate();
            if (date) {
              daysLogged.add(date.toDateString());
            }
          });

          const daysCount = daysLogged.size;

          // Store notification trigger
          await db
              .collection('users')
              .doc(userId)
              .collection('notifications')
              .add({
                type: 'monthly_progress',
                title: 'Monthly Progress Report',
                body: `You logged meals on ${daysCount} days last month!`,
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
                read: false,
              });

          console.log(`Progress report queued for user ${userId}`);
        }

        return null;
      } catch (error) {
        console.error('Error sending progress reports:', error);
        return null;
      }
    });

/**
 * Scheduled function to send inactivity reminders
 * Runs daily at 6 PM UTC
 */
exports.sendInactivityReminders = functions.pubsub
    .schedule('0 18 * * *')
    .timeZone('UTC')
    .onRun(async (context) => {
      const db = admin.firestore();
      const today = new Date();
      today.setHours(0, 0, 0, 0);

      try {
        const usersSnapshot = await db.collection('users').get();

        for (const userDoc of usersSnapshot.docs) {
          const userId = userDoc.id;

          // Check notification preferences
          const prefsDoc = await db
              .collection('users')
              .doc(userId)
              .collection('notificationSettings')
              .doc('preferences')
              .get();

          const prefs = prefsDoc.data() || {};
          if (prefs.inactivityReminder !== true) continue;

          // Check if user has logged any meals today
          const mealsSnapshot = await db
              .collection('users')
              .doc(userId)
              .collection('meals')
              .where('date', '>=', today)
              .limit(1)
              .get();

          if (mealsSnapshot.empty) {
            // No meals logged today
            await db
                .collection('users')
                .doc(userId)
                .collection('notifications')
                .add({
                  type: 'inactivity_reminder',
                  title: 'Don\'t forget to log your meals!',
                  body: 'You haven\'t logged any meals today',
                  createdAt: admin.firestore.FieldValue.serverTimestamp(),
                  read: false,
                });

            console.log(`Inactivity reminder queued for user ${userId}`);
          }
        }

        return null;
      } catch (error) {
        console.error('Error sending inactivity reminders:', error);
        return null;
      }
    });

