import 'package:curpertino_store/model/app_state_model.dart';
import 'package:curpertino_store/styles.dart';
import 'package:curpertino_store/widgets/product_row_item.dart';
import 'package:curpertino_store/widgets/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  String _terms = '';

  @override
  void initState() {
    _controller = TextEditingController()..addListener(_ontextChanged);
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<AppStateModel>(context);
    final results = model.search(_terms);
    return DecoratedBox(
        decoration: const BoxDecoration(
          color: Styles.scaffoldBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildSearchBox(),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) => ProductRowItem(
                    product: results[index],
                    lastItem: index == results.length - 1,
                  ),
                  itemCount: results.length,
                ),
              ),
            ],
          ),
        ));
  }

  void _ontextChanged() {
    setState(() {
      _terms = _controller.text;
    });
  }

  Widget _buildSearchBox() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SearchBar(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }
}
