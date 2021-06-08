//  region - asia-south1 - Mumbai

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
const topAdmin = require("./admin/admin");
const deleteF = require("./client/delete");
const reportF = require("./client/report");
const chatsF = require("./client/chat")
const matchmakingF = require("./client/matchmaking")

const nearRegion = "asia-south1";
admin.initializeApp();

// ? ----------------------------------------------------------------------------------------------------------
// deletes
exports.deleteUserCloudStorage = deleteF.deleteUserCloudStorage;
exports.deleteUserMatchMaking = deleteF.deleteUserMatchMaking;
exports.deleteUserAccount = deleteF.deleteUserAccount;
exports.iterateUserDelete = deleteF.iterateUserDelete
exports.adminDeleteUsers = topAdmin.adminDeleteUsers
//  disable user account
exports.disableUserAccount = functions.https.onCall(async (data, context) => {
  try {
    const uid = context.auth.uid;
    if (uid.length !== 0) {
      console.log("User uid : " + uid);
      await admin.auth().updateUser(context.auth.uid, {
        disabled: true,
      });
      console.log("User account disabled successfully");
    }
  } catch (error) {
    console.log("Error :" + error.toString());
  }
});
//  send push notification when heart is pressed -> FCM
exports.notifyUsersFCM = functions.https.onCall(async (data, context) => {
  try {
    var token = data.token;
    var title = data.title.toString();
    var body = data.body.toString();
    console.log("FCM token :" + token);
    var sendmessageFCM = await admin.messaging().send({
      token: token,
      notification: {
        title: title,
        body: body,
      },
    });
    console.log(sendmessageFCM);
    return "Push notification sent";
  } catch (error) {
    console.log("Error in notifing Users -> FCM : " + error.toString());
    return "Push notification failed";
  }
});

// chats
exports.automaticUnMatch = chatsF.automaticUnMatch
exports.unmatchIndividualChats = chatsF.unmatchIndividualChats
exports.replicateHeadPhotos = chatsF.replicateHeadPhoto
// ----

exports.byAdmin1 = topAdmin.byAdmin1;
// report functions
exports.fakeProfile = reportF.fakeProfile;
exports.sexuallyExplicitContent = reportF.sexuallyExplicitContent;
exports.imagesOfViolenceTorture = reportF.imagesOfViolenceTorture;
exports.hateGroup = reportF.hateGroup;
exports.illegalActivityAdvertising = reportF.illegalActivityAdvertising;
exports.profileUnder18 = reportF.profileUnder18;
exports.hateSpeech = reportF.hateSpeech;
exports.fakeLocation = reportF.fakeLocation;
exports.againstExploreDating = reportF.againstExploreDating;
// ---

// matchmaking
exports.createMatchMakingData = matchmakingF.createMatchMakingData