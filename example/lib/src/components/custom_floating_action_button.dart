import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Widget icon;
  final bool isLoading;
  const CustomFloatingActionButton({
    super.key,
    required this.child,
    required this.onPressed,
    required this.icon,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          bottom: 16,
          right: 16,
          child: SafeArea(
            bottom: true,
            left: false,
            right: true,
            top: false,
            child: FloatingActionButton(
              onPressed: isLoading ? null : onPressed,
              child: isLoading //
                  ? const Center(child: SizedBox.square(dimension: 25, child: CircularProgressIndicator()))
                  : icon,
            ),
          ),
        ),
      ],
    );
    // -- Way2
    //
    // return Scaffold(
    //   primary: false,
    //   resizeToAvoidBottomInset: false,
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: isLoading ? null : onPressed,
    //     child: isLoading //
    //         ? const Center(child: SizedBox.square(dimension: 25, child: CircularProgressIndicator()))
    //         : icon,
    //   ),
    //   body: child,
    // );

    // -- Way 3
    //
    // return SizedBox.expand(
    //   child: Flow(
    //     delegate: CustomFlowDelegate(),
    //     children: [
    //       child,
    //       Align(
    //         alignment: Alignment.bottomRight,
    //         child: SafeArea(
    //           bottom: true,
    //           left: false,
    //           right: true,
    //           top: false,
    //           child: Padding(
    //             padding: const EdgeInsets.only(bottom: 16, right: 16),
    //             child: RepaintBoundary(
    //               child: FloatingActionButton(
    //                 onPressed: isLoading ? null : onPressed,
    //                 child: isLoading //
    //                     ? const Center(child: SizedBox.square(dimension: 25, child: CircularProgressIndicator()))
    //                     : icon,
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
