import 'dart:convert';
import 'dart:io';

import 'package:care2care/ReusableUtils_/toast2.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/modals/Profile_modal.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class DocsUploadController extends GetxController {
  @override
  void onInit() {
    fetchDocumentApi();
    // TODO: implement onInit
    super.onInit();
  }

  bool uploading = false;
  List<File> selectedFiles = [];
  List<PatientDocument> uploadedDocuments = [];
  ProfileList? profileList;
  bool showUploadField = false;
  TextEditingController inputFileNameCT = TextEditingController();

  void toggleUploadField() {
    showUploadField = !showUploadField;
    update();
  }

  // Validation method for file name
  bool validateFileName(String fileName) {
    RegExp specialCharPattern = RegExp(r'[!@#\$%^&*(),?":{}|<>]');
    if (specialCharPattern.hasMatch(fileName)) {
      return false;
    }
    return true;
  }

  Future<void> pickDocuments() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );
    if (result != null) {
      selectedFiles = result.paths.map((path) => File(path!)).toList();
      for (var file in selectedFiles) {
        uploadedDocuments.add(PatientDocument(
            fileName: file.path.split('/').last,
            filePath: file.path,
            documentName: inputFileNameCT.text,
            createdAt: DateTime.now().toIso8601String()));
      }
      await multiDocUploadApi();
      update();
    } else {
      Get.snackbar('Error', 'No files selected');
    }
  }

  multiDocUploadApi() async {
    // Check if there are files to upload
    if (selectedFiles.isEmpty) {
      Get.snackbar('Error', 'No files selected for upload');
      return;
    }

    uploading = true; // Set uploading state
    update(); // Update the UI

    var id = await SharedPref().getId(); // Get patient ID
    var token = await SharedPref().getToken(); // Get authorization token
    var request = http.MultipartRequest('POST', Uri.parse(ApiUrls().DocUpload));

    // Add files to the request
    for (var file in selectedFiles) {
      request.files.add(await http.MultipartFile.fromPath('document', file.path));
    }

    // Set headers for the request
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer $token',
    });
    request.fields['patient_id'] = id!;
    request.fields['document_name'] = inputFileNameCT.text;

    // Send the request
    var res = await request.send();
    var response = await http.Response.fromStream(res);

    // Check for successful response
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      print("PDF response: $responseData");

      // Ensure the 'data' field contains 'patient_documents'
      if (responseData['data'] != null && responseData['data']['patient_documents'] != null) {
        List<dynamic> uploadedDocsJson = responseData['data']['patient_documents'];
        for (var docJson in uploadedDocsJson) {
          uploadedDocuments.add(PatientDocument.fromJson(docJson)); // Add to the list
          print(docJson); // Log for debugging
        }
      } else {
      //  Get.snackbar('Error', 'No document data returned');
      }

      inputFileNameCT.clear(); // Clear the input field
      showUploadField = false; // Hide upload field
      await fetchDocumentApi(); // Fetch updated documents
      update(); // Update the UI
      Get.snackbar('Success', 'Documents uploaded successfully!',
          snackPosition: SnackPosition.BOTTOM);
    } else if(res.statusCode == 422){
      Get.snackbar('Error', jsonDecode(response.body)["document"][0],
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar('Error', 'Failed to upload documents',
          snackPosition: SnackPosition.BOTTOM);
    }

    uploading = false; // Reset uploading state
    fetchDocumentApi();
    update(); // Final UI update

  }



  fetchDocumentApi() async {
    String? token = await SharedPref().getToken();
    try {
      var res = await http.get(
        Uri.parse(ApiUrls().patientInfoFetch),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200) {
        profileList = profileListFromJson(res.body);
        if (profileList != null) {
          uploadedDocuments = profileList!.data!.patientDocuments!;
          update();
        }
      }
    } catch (e) {
      print('error $e');
    }
  }

  bool isDeleting = false;

  deleteDocumentApi(int? index) async {
    var docDel = uploadedDocuments[index!];
    docDel.isDeletingDoc = true;
    update();
    try {
      var docIdToDelete = uploadedDocuments[index].id;
      var id = await SharedPref().getId();
      var token = await SharedPref().getToken();
      var req =
          await http.delete(Uri.parse(ApiUrls().deleteDocument), headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'id': docIdToDelete.toString(),
        'patient_id': id.toString()
      });
      if (req.statusCode == 200) {
        print("delete index$index");
        await Future.delayed(Duration(seconds: 2));
        uploadedDocuments.removeAt(index);
        showCustomToast(message: "Deleted successfully");
      } else {
        print("cant delete");
      }
    } catch (e) {
      print("error delete Api $e");
    }
    docDel.isDeletingDoc = false;
    update();
  }
}

class PatientDocument {
  int? id;
  int? patientId;
  String? fileName;
  String? documentName;
  String? filePath;
  String? createdAt;
  String? updatedAt;
  bool?isDeletingDoc;

  PatientDocument({
    this.id,
    this.patientId,
    this.fileName,
    this.filePath,
    this.documentName,
    this.createdAt,
    this.updatedAt,
    this.isDeletingDoc = false,
  });

  factory PatientDocument.fromJson(Map<String, dynamic> json) =>
      PatientDocument(
        id: json["id"],
        patientId: json["patient_id"],
        fileName: json["file_name"],
        filePath: json["file_path"],
        documentName: json["document_name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "patient_id": patientId,
        "file_name": fileName,
        "document_name": documentName,
        "file_path": filePath,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
