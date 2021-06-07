// todo only for admins
// todo only admin https req and CRUD operations
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nearRegion = "asia-south1";


exports.byAdmin1 = functions.region(nearRegion).https.onRequest(async(req,res) =>{
  // todo write what this function does
  // ? add new field in access check of users data
  try {
    if(req.method === "GET"){
      var firestore = admin.firestore()
      const FieldValue = admin.firestore.FieldValue
      var datas = await firestore.collection("Users").get()
      var batch = firestore.batch()
      datas.docs.forEach((item)=>{
        var path = item.ref.path;
        var documentRef = firestore.doc(path)
        batch.update(documentRef,{
          "access_check.get_started" : false,
        })
      })
      await batch.commit()
      res.status(200).send("Success")
    }
    else{
      res.status(500).send("Error")
    }
  } catch (error) {
    res.status(504).send("Error catched")
    
  }
  
})
