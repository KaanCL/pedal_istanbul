import 'package:flutter/material.dart';
import 'package:pedal_istanbul/providers/appstate.dart';
import 'package:pedal_istanbul/widgets/menubutton.dart';
import 'package:provider/provider.dart';

class RightMenu extends StatelessWidget {
  final VoidCallback undoRoute;
  final VoidCallback deleteRoute;
  final VoidCallback cancelEdit;
  final VoidCallback confirmEdit;
  final VoidCallback setEdit;


  const RightMenu({super.key, required this.undoRoute, required this.deleteRoute, required this.cancelEdit, required this.confirmEdit, required this.setEdit});


  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Column(
      children: [
        if (appState.isEditing)
          MenuButton(
            onPressed:cancelEdit,
            image: Image.asset('assets/images/cancel.png'),
          ),
        SizedBox(height: 5),
        if (appState.isEditing)
          MenuButton(
            onPressed: undoRoute,
            image: Image.asset('assets/images/undo.png'),
          ),
        SizedBox(height: 5),
        if (appState.isEditing || appState.selectedMarker != null)
          MenuButton(
            onPressed: deleteRoute,
            image: Image.asset('assets/images/delete.png'),
          ),
        SizedBox(height: 5),
        if (!appState.isEditing)
          MenuButton(
            onPressed: setEdit,
            image: Image.asset('assets/images/add.png'),
          ),
        SizedBox(height: 5),
        if (appState.isEditing)
          MenuButton(
            onPressed: confirmEdit,
            image: Image.asset('assets/images/check.png'),
          ),
      ],
    );
  }
}
