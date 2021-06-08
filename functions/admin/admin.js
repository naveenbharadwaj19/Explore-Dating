// todo only for admins
// todo only admin https req and CRUD operations
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nearRegion = "asia-south1";

exports.byAdmin1 = functions
  .region(nearRegion)
  .https.onRequest(async (req, res) => {
    // todo write what this function does
    // ? add new field in access check of users data
    try {
      if (req.method === "GET") {
        var firestore = admin.firestore();
        const FieldValue = admin.firestore.FieldValue;
        var datas = await firestore.collection("Users").get();
        var batch = firestore.batch();
        datas.docs.forEach((item) => {
          var path = item.ref.path;
          var documentRef = firestore.doc(path);
          batch.update(documentRef, {
            "access_check.get_started": false,
          });
        });
        await batch.commit();
        res.status(200).send("Success");
      } else {
        res.status(500).send("Error");
      }
    } catch (error) {
      res.status(504).send("Error catched");
    }
  });

exports.adminDeleteUsers = functions
  .region("asia-northeast1")
  .https.onRequest(async (req, res) => {
    // get users uid and delete them
    if (req.method === "GET") {
      var usersUid = [];
      var usersToDelete = 1000;
      var users = await admin.auth().listUsers(usersToDelete);
      users.users.forEach((item) => {
        usersUid.push(item.uid);
      });
      admin
        .auth()
        .deleteUsers(usersUid)
        .then((result) => {
          res
            .status(200)
            .send(
              `Deleted ${result.successCount} of ${usersToDelete} : failed to delete ${result.failureCount}`
            );
          return null;
        })
        .catch((error) => {
          res.status(400).send(error);
          return null;
        });
    } else {
      res.status(504).send("No method found");
    }
  });
