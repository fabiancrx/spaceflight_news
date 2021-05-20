import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:spaceflight_news/src/common/theme.dart';

/// Listens to textEditingController, but debounce updates to avoid triggering too many HTTP requests.
String _useDecouncedSearch(TextEditingController textEditingController, [int milliseconds = 200]) {
  assert(milliseconds > 0);
  final search = useState(textEditingController.text);
  useEffect(() {
    Timer? timer;
    void listener() {
      timer?.cancel();
      timer = Timer(
        Duration(milliseconds: milliseconds),
        () => search.value = textEditingController.text,
      );
    }

    textEditingController.addListener(listener);
    return () {
      timer?.cancel();
      textEditingController.removeListener(listener);
    };
  }, [textEditingController]);

  return search.value;
}

class SearchBar extends HookWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textEditingController = useTextEditingController();
    final focusNode = useFocusNode();
    return Container(
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 20, top: 4),
        padding: EdgeInsets.only(bottom: 0),
        decoration: BoxDecoration(
            color: Colors.black.withOpacity(.3), borderRadius: const BorderRadius.all(Radius.circular(24))),
        child: TextField(
          controller: textEditingController,
          autofocus: true,
          focusNode: focusNode,
          onSubmitted: (value) {
            focusNode.unfocus();
          },
          cursorColor: Colors.white,
          cursorHeight: 23,
          cursorWidth: 1,
          onChanged: (value) {},
          textInputAction: TextInputAction.search,
          style: TextStyles.body2.copyWith(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              icon: Padding(
                padding: const EdgeInsets.only(left: 19.0),
                child: Icon(
                  Icons.search,
                  color: Colors.white.withOpacity(.8),
                  size: 22,
                ),
              )),
          expands: false,
        ));
  }
}
