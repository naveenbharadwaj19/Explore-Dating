// * region - asia-south1 - Mumbai

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { Storage } = require("@google-cloud/storage");
admin.initializeApp();

// * assign memory timeout , region here:
// * DUCS -> deleteUserCloudStorage
const runTimeForDUCS = { timeoutSeconds: 200, memory: "512MB" };
// * run time for isdeleted field in firestore
const runTimeForIsdeletedField = { timeoutSeconds: 60, memory: "256MB" };

const nearRegion = "asia-south1";
// -------------------------------------------

// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// * delete user cloud storage
exports.deleteUserCloudStorage = functions
  .region(nearRegion)
  .runWith(runTimeForDUCS)
  .auth.user()
  .onDelete(async (user) => {
    try {
      var userId = user.uid;
      console.log("User id : " + userId);
      // * declare bucket name
      // ! check for project id while adding domain name :
      const storage = new Storage({ projectId: "exploreapp-3572c" });
      const bucket = storage.bucket("gs://exploreapp-3572c.appspot.com");
      await bucket.deleteFiles({
        force: true,
        prefix: "Userphotos/" + userId,
      });
      console.log("Photos deleted successfully");
    } catch (error) {
      console.log("Error in processing : " + error.toString());
    }
  });

// * Trigger when isdeleted == true && islogin == true in firestore -> these should happen in when user auth deleted
// * will show error to user
exports.isDelLogFieldUpdated = functions
  .region(nearRegion)
  .runWith(runTimeForIsdeletedField)
  .auth.user()
  .onDelete(async (user) => {
    try {
      var userId = user.uid;
      console.log("User id : " + userId);
      var fetchData = await admin
        .firestore()
        .doc("Userstatus/" + userId)
        .get();
      var updateDeleteField = admin.firestore().doc("Userstatus/" + userId);
      if (fetchData.get("isloggedin") === true) {
        console.log("User is currently logged in");
        await updateDeleteField.update({ isdeleted: true });
        console.log("isdeleted field updated successfully");
      } else if (fetchData.get("isloggedin") === false) {
        console.log("No user logged in . So deleting userstatus -> uid");
        await updateDeleteField.delete();
        console.log("Successfully deleted");
      }
    } catch (error) {
      console.log("Error :" + error.toString());
    }
  });

// * deletes user match making details
exports.deleteUserMatchMaking = functions
  .region(nearRegion)
  .runWith({ timeoutSeconds: 60, memory: "128MB" })
  .firestore.document("Users/{userId}")
  .onDelete(async (snap, context) => {
    try{
      var userId = snap.get("bio.user_id");
      var gender = snap.get("bio.gender").toString();
      console.log("User id : " + userId);
      const searchCurrentUserDb = await admin.firestore().collection("Matchmaking/simplematch/MenWomen").where("uid","==",userId).get();
      searchCurrentUserDb.docs.forEach(value =>{
        var documentId = value.id;
        var fullPath = value.ref.path;
        console.log("Document id retrieved : " + documentId);
        admin.firestore().doc(fullPath).delete();
        console.log("Deleted user data in matchmaking");
      })
    }
    catch (error){
      console.log("Error :" + error.toString());
    }
  });
