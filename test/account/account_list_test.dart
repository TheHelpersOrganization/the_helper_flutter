import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocktail/mocktail.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/common/widget/error_widget.dart';
import 'package:the_helper/src/common/widget/no_data_found.dart';
import 'package:the_helper/src/features/account/data/account_repository.dart';
import 'package:the_helper/src/features/account/domain/account.dart';
import 'package:the_helper/src/features/account/domain/account_query.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/controllers/account_manage_screen_controller.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/screens/account_manage_screen.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/widgets/account_list.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/widgets/active_account_list_item.dart';
import 'package:the_helper/src/features/account/presentation/account_admin_manage/widgets/banned_account_list_item.dart';
import 'package:the_helper/src/utils/dio.dart';

class MockRepository extends Mock implements AccountRepository {}

class MockPaging extends Mock implements ScrollPagingControlNotifier {
  @override
  // TODO: implement accountRepository
  AccountRepository get accountRepository => MockRepository();
}

class Listener<T> extends Mock {
  void call(T? previous, T next);
}

void main() {
  late MockRepository mockRepository;
  late MockPaging mockPaging;

  setUp(() {
    mockRepository = MockRepository();
    mockPaging = MockPaging();
  });

  final accountList = <AccountModel>[
    // AccountModel(
    //   id: 1,
    //   email: 'email 1',
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    // ),
    // AccountModel(
    //   id: 2,
    //   email: 'email 2',
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    // ),
    // AccountModel(
    //   id: 3,
    //   email: 'email 3',
    //   createdAt: DateTime.now(),
    //   updatedAt: DateTime.now(),
    // )
  ];

  void mockRepositoryRequest() {
    when(() => mockRepository.getAll()).thenAnswer((_) async => accountList);
  }

  Widget createTestableWidget(Widget child) {
    return ProviderScope(
      overrides: [
        accountRepositoryProvider.overrideWithValue(mockRepository),
        scrollPagingControlNotifier.overriddenFamily
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('show list', (WidgetTester tester) async {
    const tabIndex = 0;

    final provider = scrollPagingControlNotifier(tabIndex);
    mockRepositoryRequest();
    // mockPagingRequest();
    await tester.pumpWidget(
        createTestableWidget(RiverPagedBuilder<int, AccountModel>.autoDispose(
      firstPageKey: 0,
      provider: provider,
      pagedBuilder: (controller, builder) => PagedListView(
        pagingController: controller,
        builderDelegate: builder,
      ),
      itemBuilder: (context, item, index) {
        if (tabIndex == 0) {
          return ActiveAccountListItem(
            data: item,
            tabIndex: tabIndex,
          );
        } else {
          return BannedAccountListItem(data: item, tabIndex: tabIndex);
        }
      },
      limit: 5,
      pullToRefresh: true,
      firstPageErrorIndicatorBuilder: (context, controller) =>
          CustomErrorWidget(
        onRetry: () => controller.retryLastFailedRequest(),
      ),
      newPageErrorIndicatorBuilder: (context, controller) => CustomErrorWidget(
        onRetry: () => controller.retryLastFailedRequest(),
      ),
      noItemsFoundIndicatorBuilder: (context, _) => const NoDataFound.simple(
        contentTitle: 'No accounts found',
      ),
    )));
    await tester.pump(const Duration(seconds: 3));

    // expect(find.text('Active'), findsOneWidget);
    // expect(find.text('Banned'), findsOneWidget);
    // expect(find.text('Quick filter'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('No accounts found'), findsOneWidget);
  }
  );
}
