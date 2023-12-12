import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import '../../../data/models/animal_model.dart';

class AnimalViewPage extends StatelessWidget {
  const AnimalViewPage({Key? key, required this.animal}) : super(key: key);
  final AnimalModel animal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(animal.name)),
      body: ModelViewer(
        src: animal.modelUrl,
        alt: animal.name,
        ar: true,
        disableZoom: true,
      ),
    );
  }
}
