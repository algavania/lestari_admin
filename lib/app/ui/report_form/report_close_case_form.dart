import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/data/models/report_model.dart';
import 'package:lestari_admin/widgets/custom_text_field.dart';
import 'package:sizer/sizer.dart';

class ReportCloseCaseFormPage extends StatefulWidget {
  final ReportModel? reportModel;
  const ReportCloseCaseFormPage({Key? key, this.reportModel}) : super(key: key);

  @override
  State<ReportCloseCaseFormPage> createState() => _ReportCloseCaseFormPageState();
}

class _ReportCloseCaseFormPageState extends State<ReportCloseCaseFormPage> {
  final List<String> _actionValues = <String>['Pilih', 'Perubahan data detail hewan', 'Hapus hewan', 'Tidak ada aksi yang dilakukan'];
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedAction = 'Pilih';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.reportModel != null) _setCurrentInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(widget.reportModel == null ? 'Tutup Kasus' : 'Tutup Kasus'),
      body: SingleChildScrollView(
        padding: SharedCode.defaultPagePadding,
        child: _buildForm(),
      ),
      bottomNavigationBar: _buildBottomWidget(),
    );
  }

  void _setCurrentInfo() {
    _selectedAction = widget.reportModel?.action?? 'Pilih';
    _descriptionController.text = widget.reportModel?.reason ?? '';
  }

  _buildForm() {
    return Form(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildDropdownField('Tindakan yang dilakukan'),
      const SizedBox(height: 15.0),
      _buildTextField('Alasan pemberlakukan tindakan', _descriptionController, isMultiline: true, hintText: 'Tindakan dilakukan....'),
    ],));
  }

  _buildDropdownField(String title) {
    String selectedValue = 'Value';
    List<String> values = [];

    switch (title) {
      case 'Tindakan yang dilakukan':
        selectedValue = _selectedAction;
        values = _actionValues;
        break;

    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title*',
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5.0),
        InputDecorator(
          decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: ColorValues.lightGrey), borderRadius: BorderRadius.circular(7.0))
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w400, color: ColorValues.onyx),
                value: selectedValue,
                isDense: true,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down_rounded, size: 20.0),
                onChanged: (String? value) {
                  setState(() {
                    switch (title) {
                      case 'Tindakan yang dilakukan':
                        _selectedAction = value!;
                        break;
                    }
                  });
                },
                items: values.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildTextField(String labelText, TextEditingController controller, {bool isMultiline = false, String? hintText}) {
    return Column( crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '$labelText*',
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 5.0),
      CustomTextField(
          isRequired: true,
          controller: controller,
          minLines: isMultiline ? 5 : 1,
          maxLines: isMultiline ? 10 : 1,
          maxLength: isMultiline ? 1000 : null,
          hintText: hintText
      ),
    ],
    );
  }

  _buildAppBar(String title) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios, size: 20.0, color: ColorValues.grey),
      ),
      elevation: 0,
    );
  }

  _buildBottomWidget() {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(color:Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ]),
      child: ElevatedButton(
        onPressed: () {
        },
        child: Text(widget.reportModel == null ? 'Tutup Kasus' : 'Tutup Kasus'),
      ),
    );
  }

}
