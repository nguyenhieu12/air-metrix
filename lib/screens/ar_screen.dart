import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' as vector64;

class ArScreen extends StatefulWidget {
  const ArScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  ArCoreController? arCoreController;

  augmentedRealityViewCreated(ArCoreController coreController) {
    arCoreController = coreController;

    displaySphere(arCoreController!);
  }

  displaySphere(ArCoreController coreController) async {
    final ByteData textureBytes = await rootBundle.load(widget.imagePath);

    final materials = ArCoreMaterial(
        color: Colors.blue, textureBytes: textureBytes.buffer.asUint8List());

    final sphere = ArCoreSphere(materials: [materials]);

    final node =
        ArCoreNode(shape: sphere, position: vector64.Vector3(0, 0, -1.5));

    arCoreController!.addArCoreNode(node);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              'AR View',
              style: TextStyle(
                  fontSize: 22.w,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
          centerTitle: true,
          leading: _buildCloseButton(context: context),
        ),
        body: ArCoreView(
          onArCoreViewCreated: augmentedRealityViewCreated,
        ),
      ),
    );
  }

  Widget _buildCloseButton({required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 26.w,
        ),
      ),
    );
  }
}
