import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/tv_series_top_rated/tv_series_top_rated_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockTvSeriesTopRatedBloc
    extends MockBloc<TvSeriesTopRatedEvent, TvSeriesTopRatedState>
    implements TvSeriesTopRatedBloc {}

class TvSeriesTopRatedEventFake extends Fake implements TvSeriesTopRatedEvent {}

class TvSeriesTopRatedStateFake extends Fake implements TvSeriesTopRatedState {}

@GenerateMocks([TvSeriesTopRatedBloc])
void main() {
  late MockTvSeriesTopRatedBloc mockTvSeriesTopRatedBloc;

  setUpAll(() {
    registerFallbackValue(TvSeriesTopRatedEventFake());
    registerFallbackValue(TvSeriesTopRatedStateFake());
  });

  setUp(() {
    mockTvSeriesTopRatedBloc = MockTvSeriesTopRatedBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesTopRatedBloc>(
      create: (_) => mockTvSeriesTopRatedBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockTvSeriesTopRatedBloc.state)
        .thenReturn(TvSeriesTopRatedLoading());

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    when(() => mockTvSeriesTopRatedBloc.stream).thenAnswer(
      (_) => Stream.value(TvSeriesTopRatedHasData(tTvList)),
    );

    when(() => mockTvSeriesTopRatedBloc.state)
        .thenReturn(TvSeriesTopRatedHasData(tTvList));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    when(() => mockTvSeriesTopRatedBloc.stream).thenAnswer(
      (_) => Stream.value(TvSeriesTopRatedError("Error Message")),
    );

    when(() => mockTvSeriesTopRatedBloc.state)
        .thenReturn(TvSeriesTopRatedError("Error Message"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(textFinder, findsOneWidget);
  });
}
