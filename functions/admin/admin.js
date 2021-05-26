// todo only for admins
// todo only admin https req and CRUD operations
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nearRegion = "asia-south1";


exports.byAdmin1 = functions.region(nearRegion).https.onRequest(async(req,res) =>{
  // todo write what this function does
  // ? update uids to convo_uids in chats/auto-id
  try {
    if(req.method === "GET"){
      var firestore = admin.firestore()
      const FieldValue = admin.firestore.FieldValue
      var datas = await firestore.collection("Chats").get()
      datas.docs.forEach((item)=>{
        var documentRef = item.ref.path
        firestore.doc(documentRef).update({
          "uids" : FieldValue.delete()
        })
        
      })
      res.status(200).send("Success")
    }
    else{
      res.status(500).send("Error")
    }
  } catch (error) {
    res.status(504).send("Error catched")
    
  }
  
})
