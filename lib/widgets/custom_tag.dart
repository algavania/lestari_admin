import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTag extends StatelessWidget {
  final String tag;
  const CustomTag({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 8),
      decoration: BoxDecoration(
          color: _getTagColor(tag).withOpacity(0.5),
          borderRadius: BorderRadius.circular(5.0)
      ),
      child: Text(tag, style: GoogleFonts.poppins(fontSize: 10)),
    );
  }

  Color _getTagColor(String tag) {
    Color color;
    switch (tag) {
      case 'Pisces':
        color = const Color(0xFF74DBDB);
        break;
      case 'Amphibia':
        color = const Color(0xFF81D8A4);
        break;
      case 'Reptilia':
        color = const Color(0xFFB2D994);
        break;
      case 'Aves':
        color = const Color(0xFFFFD93D);
        break;
      case 'Mamalia':
        color = const Color(0xFFC0A9FF);
        break;
      case 'Karnivora':
        color = const Color(0xFFFF9292);
        break;
      case 'Herbivora':
        color = const Color(0xFFA0F36D);
        break;
      case 'Omnivora':
        color = const Color(0xFF8D9EFF);
        break;
      case 'Punah (EX)':
        color = const Color(0xFF343A40);
        break;
      case 'Punah Alam Liar (EW)':
        color = const Color(0xFF780000);
        break;
      case 'Kritis (CR)':
        color = const Color(0xFFFF4949);
        break;
      case 'Terancam Punah (EN)':
        color = const Color(0xFFFF9F45);
        break;
      case 'Rentan (VU)':
        color = const Color(0xFFFBD148);
        break;
      case 'Hampir Terancam (NT)':
        color = const Color(0xFFCCE227);
        break;
      case 'Risiko Rendah (LC)':
        color = const Color(0xFF60C659);
        break;
      case 'Informasi Kurang (DD)':
        color = const Color(0xFFD1D1C5);
        break;
      case 'Belum Evaluasi (NE)':
        color = const Color(0xFFFFFFFF);
        break;
      case 'Sosialisasi':
        color = const Color(0xFFFFE162);
        break;
      case 'Aksi':
        color = const Color(0xFFFFB992);
        break;
      case 'Donasi':
        color = const Color(0xFFACC8FF);
        break;
      default:
        color = const Color(0xFFCACACA);
        break;
    }
    return color;
  }
}
