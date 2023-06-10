import 'package:flutter/material.dart';
import 'package:suns_med/src/Widgets/search/search.dart';

typedef SearchFilter<T> = List<String> Function(T t);
typedef ResultBuilder<T> = Widget Function(T t);

class SearchPage<T> extends CustomSearchDelegate<T> {
  final bool showItemsOnEmpty;

  final Widget suggestion;

  final Widget failure;

  final Function onPress;

  final ResultBuilder<T> builder;

  final SearchFilter<T> filter;

  final String searchLabel;

  final List<T> items;

  final ThemeData barTheme;

  final bool itemStartsWith;

  final bool itemEndsWith;

  final TextEditingController controller;

  SearchPage({
    this.suggestion = const SizedBox(),
    this.failure = const SizedBox(),
    @required this.builder,
    @required this.filter,
    @required this.items,
    this.showItemsOnEmpty = false,
    this.searchLabel,
    this.onPress,
    this.barTheme,
    this.controller,
    this.itemStartsWith = false,
    this.itemEndsWith = false,
  })  : assert(suggestion != null),
        assert(failure != null),
        assert(builder != null),
        assert(filter != null),
        assert(items != null),
        assert(showItemsOnEmpty != null),
        super(searchFieldLabel: searchLabel, queryTextController: controller);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return barTheme ??
        Theme.of(context).copyWith(
          textTheme: TextTheme(
            headline6: TextStyle(
              fontFamily: 'Montserrat-M',
              color: Theme.of(context).primaryTextTheme.headline6.color,
              fontSize: 20,
            ),
          ),
          backgroundColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(
              fontFamily: 'Montserrat-M',
              color: Theme.of(context).primaryTextTheme.caption.color,
              fontSize: 20,
            ),
          ),
        );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      /*AnimatedOpacity(
        opacity: query.isNotEmpty ? 1.0 : 0.0,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        child: IconButton(
          icon: Icon(
            Icons.clear,
            color: Colors.white,
          ),
          onPressed: () => query = '',
        ),
      )*/
      IconButton(
        icon: Icon(
          Icons.search,
          color: Colors.white,
        ),
        onPressed: onPress,
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: BackButtonIcon(),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);

  @override
  Widget buildSuggestions(BuildContext context) {
    final String cleanQuery = query.toLowerCase().trim();

    final List<T> result = items
        .where(
          (item) =>
              filter(item).map((value) => value?.toLowerCase()?.trim()).any(
            (value) {
              if (itemStartsWith == true && itemEndsWith == true) {
                return value == cleanQuery;
              } else if (itemStartsWith == true) {
                return value?.startsWith(cleanQuery) == true;
              } else if (itemEndsWith == true) {
                return value?.endsWith(cleanQuery) == true;
              } else {
                return value?.contains(cleanQuery) == true;
              }
            },
          ),
        )
        .toList();

    return cleanQuery.isEmpty && !showItemsOnEmpty
        ? suggestion
        : result.isEmpty
            ? failure
            : ListView(children: result.map(builder).toList());
  }
}
