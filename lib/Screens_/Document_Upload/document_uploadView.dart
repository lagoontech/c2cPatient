import 'package:auto_size_text/auto_size_text.dart';
import 'package:care2care/ReusableUtils_/toast2.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../../ReusableUtils_/AppColors.dart';
import '../../ReusableUtils_/appBar.dart';
import '../../ReusableUtils_/customLabel.dart';
import '../../ReusableUtils_/image_background.dart';
import '../../ReusableUtils_/sizes.dart';
import 'controller/document_upload_controller.dart';

class DocumentUploadView extends StatelessWidget {
  DocumentUploadView({super.key});

  String? selectedValue;

  final DocsUploadController controller = Get.put(DocsUploadController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        appBar: CustomAppBar(
          title: 'Medical Records',
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            children: [
              DottedBorder(
                  color: Colors.grey,
                  child: InkWell(
                    onTap: () async {
                      controller.toggleUploadField();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            kHeight5,
                            CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              radius: 22,
                              child: Icon(
                                EneftyIcons.document_upload_outline,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            Text(
                              "Click to upload",
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                          ]),
                    ),
                  )),
              kHeight15,
              GetBuilder<DocsUploadController>(builder: (v) {
                return v.showUploadField
                    ? Row(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.77,
                            child: TextField(
                              decoration: InputDecoration(
                                  hintText:
                                      'Avoid spaces and symbols in file name',
                                  hintStyle: GoogleFonts.firaCode(
                                      fontSize: 10.sp, color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 10.w),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5)),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 0.5))),
                              controller: v.inputFileNameCT,
                            ),
                          ),
                          kWidth10,
                          v.uploading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 0.6,
                                  ),
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    String fileName = v.inputFileNameCT.text;
                                     if(v.inputFileNameCT.text.isEmpty){
                                      showCustomToast(
                                          message: 'Please Enter File name');
                                    }else{
                                      await controller.pickDocuments();
                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        Colors.green.withOpacity(0.4),
                                    radius: 20,
                                    child: Icon(
                                      EneftyIcons.document_upload_outline,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                        ],
                      )
                    : SizedBox.shrink();
              }),
              kHeight15,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GetBuilder<DocsUploadController>(builder: (v) {
                      return CustomLabel(
                        text: "Uploaded Documents",
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                      );
                    }),
                  ),
                  GetBuilder<DocsUploadController>(builder: (v) {
                    return CustomLabel(
                      text: "${v.uploadedDocuments.length} Items",
                      fontSize: 15.sp,
                      color: AppColors.primaryColor,
                    );
                  }),
                ],
              ),
              kHeight15,
              GetBuilder<DocsUploadController>(builder: (v) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: v.uploadedDocuments.length,
                    itemBuilder: (context, index) {
                      final doc = v.uploadedDocuments[index];
                      return Upload(
                        index: index,
                        url: doc.filePath!,
                        DeleteCallback: () {
                          v.deleteDocumentApi(index);
                          v.update();
                          print(index);
                        },
                        radiusSize: 24.r,
                        heading: doc.documentName ?? 'doc',
                        message: 'Uploaded on: ${doc.createdAt}',
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ));
  }
}

class Upload extends StatelessWidget {
  final String? heading;
  final String? message;
  final IconData? icons;
  final Color? circleColor;
  final Color? iconColor;
  VoidCallback? DeleteCallback;
  VoidCallback? ViewCallback;
  double? radiusSize;
  int?index;
  String ?url;

  Upload({
    super.key,
    this.heading,
    this.message,
    this.icons,
    this.DeleteCallback,
    this.ViewCallback,
    this.circleColor,
    this.iconColor,
    this.radiusSize,this.index,
    this.url
  });

  final DocsUploadController controller = Get.put(DocsUploadController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Container(
                  padding: EdgeInsets.all(9.r),
                  height: 48.h,
                  width: 48.w,
                  child: Image.asset("assets/images/pdf-2616 1.png"))),
          kWidth10,
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.06,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    heading!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black,
                    ),
                  ),
                  AutoSizeText(
                    message ?? "sujnc901@gmail.com",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          GetBuilder<DocsUploadController>(builder: (v) {
            return GestureDetector(
              onTap: (){
                downloadAndOpenPdf(context,url!,heading!);
              },
              child: CircleAvatar(
                backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                radius: 20,
                child: Icon(
                  EneftyIcons.save_add_outline,
                  color: iconColor,
                ),
              ),
            );
          }),
          kWidth15,
          GetBuilder<DocsUploadController>(builder: (v) {
            var data = v.uploadedDocuments[index!];
            return GestureDetector(
              onTap: DeleteCallback,
              child: CircleAvatar(
                backgroundColor: Colors.red.withOpacity(0.1),
                radius: 20,
                child: data.isDeletingDoc!
                    ? Center(
                        child: Center(
                          child: SizedBox(
                            height: 12.h,
                            width: 13.w,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 0.6,
                            ),
                          ),
                        ),
                      )
                    : Icon(
                        EneftyIcons.trash_bold,
                        color: iconColor,
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  //

  Future<void> downloadAndOpenPdf(BuildContext context,String pdfUrl,String title) async {
    try {
      // Show downloading message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Downloading PDF...")),
      );

      // Get directory to save the file
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$title.pdf";

      // Download the file
      Dio dio = Dio();
      print(ApiUrls.baseUrl+"/"+pdfUrl);
      await dio.download(ApiUrls.baseUrl+"/"+pdfUrl, filePath);

      // Show download complete message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("PDF downloaded successfully!")),
      );
      await OpenFilex.open(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to download or open PDF: $e")),
      );
    }
  }

}
