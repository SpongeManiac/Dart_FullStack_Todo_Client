import 'package:flutter/material.dart';

import 'base_page.dart';

enum ViewState {
  create,
  read,
  update,
  delete,
}

abstract class CRUDState<T> extends State<BasePage> {
  //CRUDPage({super.key, required super.title});

  ValueNotifier<ViewState> stateNotifier =
      ValueNotifier<ViewState>(ViewState.read);
  ViewState get state => stateNotifier.value;
  set state(state) => stateNotifier.value = state;

  ValueNotifier<T?> editingNotifier = ValueNotifier(null);
  T? get itemToEdit => editingNotifier.value;
  set itemToEdit(newItem) => editingNotifier.value = newItem;

  //view switching
  Future<void> setViewState(ViewState state, T? item) async {
    if ((state == ViewState.update || state == ViewState.delete)) {}

    switch (state) {
      case ViewState.create:
        await setCreate();
        break;
      case ViewState.read:
        await setRead();
        break;
      case ViewState.update:
        if (item == null) {
        } else {
          await setUpdate(item);
        }
        break;
      case ViewState.delete:
        if (item == null) {
        } else {
          await setDelete(item);
        }
        break;
    }
  }

  Future<void> setCreate() async {
    itemToEdit = null;
    state = ViewState.create;
  }

  Future<void> setRead() async {
    itemToEdit = null;
    state = ViewState.read;
  }

  Future<void> setUpdate(T item) async {
    itemToEdit = item;
    state = ViewState.update;
  }

  Future<void> setDelete(T item) async {
    itemToEdit = item;
    state = ViewState.delete;
  }

  Future<void> cancel() async {
    await setRead();
  }

  //crud views
  Widget createView(BuildContext context);
  Widget readView(BuildContext context);
  Widget updateView(BuildContext context);
  Widget deleteView(BuildContext context);

  //crud functions
  Future<T> create();
  Future<T> update(T item);
  Future<List<T>> updateAll(List<T> items) async {
    List<T> updated = [];
    for (T item in items) {
      updated.add(await update(item));
    }
    return updated;
  }

  Future<void> delete(T item);
  Future<void> deleteAll(List<T> items) async {
    for (T item in items) {
      await delete(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ViewState>(
      valueListenable: stateNotifier,
      builder: (context, state, _) {
        switch (state) {
          case ViewState.create:
            return createView(context);
          case ViewState.read:
            return readView(context);
          case ViewState.update:
            return updateView(context);
          case ViewState.delete:
            return deleteView(context);
          default:
            return const Center(child: Text('Invalid State'));
        }
      },
    );
  }
}
