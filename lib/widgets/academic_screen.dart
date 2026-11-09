import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const academicGuinda = Color(0xFF6F263B);
const academicBeige = Color(0xFFEBE3D5);

/// Marco visual compartido por las pantallas de la práctica.
class AcademicScreen extends StatelessWidget {
  const AcademicScreen({
    super.key,
    required this.title,
    required this.child,
    this.header,
  });

  final String title;
  final Widget child;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: academicGuinda,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: SvgPicture.asset(
                'assets/logo.svg',
                height: 40,
                semanticsLabel: 'Logo',
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 52),
                              child: header ??
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: academicGuinda)),
                                  ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                tooltip: 'Regresar',
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                style: IconButton.styleFrom(
                                  backgroundColor: academicBeige,
                                  foregroundColor: academicGuinda,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                icon: const Icon(Icons.arrow_back),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(child: child),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
