import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../components/z_button.dart';
import '../../components/z_text_form_field.dart';
import '../../models/support.dart';
import '../../models_providers/app_controls_provider.dart';

import '../../models_services/api_support_service.dart';
import '../../models_services/firestore_service.dart';
import '../../utils/z_utils.dart';
import '../../utils/z_validators.dart';

class SupportPage extends StatefulWidget {
  SupportPage({Key? key}) : super(key: key);

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  Support support = Support();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(foregroundColor: Colors.transparent, title: Text('Support')),
      body: Form(
        key: formKey,
        child: ListView(
          children: [
            SizedBox(height: 32),
            Image.asset('assets/images/support.png', height: 150),
            SizedBox(height: 32),
            ZTextFormField(
              labelText: 'Name',
              onSaved: (v) {
                support.name = v;
              },
            ),
            ZTextFormField(
                labelText: 'Email',
                validator: ZValidators.email,
                keyboardType: TextInputType.emailAddress,
                onSaved: (v) {
                  support.email = v;
                }),
            ZTextFormField(
              labelText: 'Message',
              onSaved: (v) {
                support.message = v;
              },
              maxLines: 4,
            ),
            SizedBox(height: 32),
            ZButton(
              text: 'Submit',
              onTap: _onSubmit,
              isLoading: isLoading,
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    AppControlsProvider appControlsProvider = Provider.of<AppControlsProvider>(context, listen: false);
    final appControls = appControlsProvider.appControls;

    if (formKey.currentState == null) return;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() => isLoading = true);
      var res = await FirestoreService.addSupport(support);
      if (res) ApiService.sendSupportEmail(support: support, apiBaseUrl: appControls.adminUrl);
      if (res) {
        Get.back();
        ZUtils.showToastSuccess(message: 'Email sent successfully');
      }
      setState(() => isLoading = false);
    }
  }
}
