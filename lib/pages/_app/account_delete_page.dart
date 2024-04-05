import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/z_button.dart';
import '../../components/z_text_form_field.dart';
import '../../models_providers/app_controls_provider.dart';
import '../../models_providers/app_provider.dart';
import '../../models_providers/auth_provider.dart';
import '../../models_services/api_authuser_service.dart';

class AccountDeletePage extends StatefulWidget {
  AccountDeletePage({Key? key}) : super(key: key);

  @override
  _AccountDeletePageState createState() => _AccountDeletePageState();
}

class _AccountDeletePageState extends State<AccountDeletePage> {
  final formKey = GlobalKey<FormState>();
  String deleteText = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      extendBody: true,
      body: Form(
        key: formKey,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 32),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Delete Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
                  SizedBox(height: 12),
                  Text(
                    'Please note once you initiate the deletion process, \nit cannot be undone. \nPlease type "DELETE"',
                    style: TextStyle(fontSize: 14, height: 1.8, color: Theme.of(context).textTheme.bodySmall!.color, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            ZTextFormField(
              labelText: '',
              onValueChanged: ((value) {
                deleteText = value;
                setState(() {});
              }),
              onSaved: (v) {},
            ),
            SizedBox(height: 34),
            ZButton(
              text: 'Delete Account',
              onTap: _onSubmit,
              isDisabled: deleteText.toLowerCase().trim() != 'delete',
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _onSubmit() async {
    if (formKey.currentState == null) return;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() => isLoading = true);

      AppControlsProvider appControlsProvider = Provider.of<AppControlsProvider>(context, listen: false);
      final appControls = appControlsProvider.appControls;

      var res = await ApiAuthUserService.deleteAccount(apiBaseUrl: appControls.adminUrl);

      Provider.of<AppProvider>(context, listen: false).cancleAllStreams();
      await Provider.of<AuthProvider>(context, listen: false).initReload();

      if (res == true) Navigator.of(context).pop();

      setState(() => isLoading = false);
    }
  }
}
