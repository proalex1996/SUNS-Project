import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_base.dart';

class BlocProvider<TEvent, TState, TBloc extends BlocBase<TEvent, TState>>
    extends InheritedWidget {
  final TBloc bloc;
  //Todo Chức năng này chưa update vì cân nhắc tới vấn đề performance render và vị trí render của phần loading đè lên state cũ
  final bool useLoading;
  BlocProvider({
    Key key,
    this.useLoading = false,
    this.navigator,
    @required this.bloc,
    @required this.builder,
  })  : assert(builder != null),
        assert(bloc != null),
        super(
          key: key,
          child: StreamBuilder(
            stream: bloc.stream,
            initialData: bloc.state,
            builder: (BuildContext context, AsyncSnapshot<TState> snapshot) {
              if (navigator != null) {
                WidgetsBinding.instance
                    .addPostFrameCallback((x) => navigator(bloc.state));
              }
              return builder(bloc.state);
            },
          ),
        );

  final Widget Function(TState state) builder;
  final void Function(TState current) navigator;

  @override
  bool updateShouldNotify(BlocProvider oldWidget) =>
      this.bloc != oldWidget.bloc;
}

/*
//Example
 BlocProvider(
                bloc: bloc,
                builder: (counter, allowRender) {
                  return Text(
                    '$counter',
                    style: Theme.of(context).textTheme.headline4,
                  );
                }),
 */
