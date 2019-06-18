import 'package:flutter/material.dart';

class TextInputDialog extends StatefulWidget {
  TextInputDialog(
      {Key key,
      this.onFinish,
      this.title,
      this.defaultText,
      this.keyboardType = TextInputType.text,
      this.hint,
      this.confirmText,
      this.cancelText,
      this.warning = false})
      : super(key: key);

  Function(bool, String) onFinish;
  String title;
  String defaultText;
  String hint;
  String confirmText;
  String cancelText;
  bool warning;
  TextInputType keyboardType;

  _TextInputDialogState createState() => _TextInputDialogState();
}

class _TextInputDialogState extends State<TextInputDialog> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    textEditingController.text = widget.defaultText ?? "";
  }

  @override
  Widget build(BuildContext context) {
    Color confirmButtonColor = widget.warning ? Colors.deepOrange : Colors.black;

    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: textEditingController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.hint ?? "",
        ),
        keyboardType: widget.keyboardType,
        onChanged: (value) {
          setState(() {});
        },
        onSubmitted: (value) {
          if (textEditingController.text.length == 0) return;
          if (widget.onFinish != null)
            widget.onFinish(true, textEditingController.text);
          Navigator.of(context).pop();
        },
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(widget.cancelText, style: TextStyle(color: Colors.black)),
          splashColor: Colors.black26,
          highlightColor: Colors.black12,
          onPressed: () {
            if (widget.onFinish != null) widget.onFinish(false, null);
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text(widget.confirmText,
              style: TextStyle(
                  color: (textEditingController.text.length > 0) ? confirmButtonColor : Colors.black38)),
          splashColor: Colors.black26,
          highlightColor: Colors.black12,
          onPressed: (textEditingController.text.length > 0)
              ? () {
                  if (widget.onFinish != null)
                    widget.onFinish(true, textEditingController.text);
                  Navigator.of(context).pop();
                }
              : null,
        ),
      ],
    );
  }
}
