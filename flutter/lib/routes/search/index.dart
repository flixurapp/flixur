import "package:dio/dio.dart";
import "package:flixur/api.dart";
import "package:flixur/hooks.dart";
import "package:flixur/settings.dart";
import "package:flixur/ui/icons.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/ui/main_nav/common.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";
import "package:openapi/openapi.dart";

class const SearchView({super.key}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    final searchFocus = useFocusNode();
    final searchDebounce = useFlixurDebounced();

    // focus on re-tap
    final rootTapSignal = MainNavWrapper.sectionFromID(.search)?.rootTapSignal;
    useEffect(() {
      if (rootTapSignal == null) return null;
      rootTapSignal.addListener(searchFocus.requestFocus);
      return () => rootTapSignal.removeListener(searchFocus.requestFocus);
    }, [rootTapSignal]);

    final searchFuture =
        useState<
          ({Future<ApiResult<ArtistSearchBody>> future, VoidCallback cancel})?
        >(null);
    final results = useFuture(searchFuture.value?.future);

    // cancel search when leaving the view
    useEffect(
      () =>
          () => searchFuture.value?.cancel(),
      const [],
    );

    return ListView(
      children: [
        TextField(
          controller: searchController,
          focusNode: searchFocus,
          onChanged: (value) {
            if (value.isEmpty) {
              searchDebounce.cancel();
              searchFuture.value?.cancel();
              searchFuture.value = null;
              return;
            }

            searchDebounce.run(() {
              searchFuture.value?.cancel();
              final cancelToken = CancelToken();
              searchFuture.value = (
                future: Api.request(
                  (a) => a.getArtistsApi().searchArtists(
                    searchArtistsRequest: .new(
                      (req) => req
                        ..query = value
                        ..plugin = "musicbrainz",
                    ),
                    cancelToken: cancelToken,
                  ),
                ),
                cancel: cancelToken.cancel,
              );
            });
          },
          textAlignVertical: .center,
          decoration: InputDecoration(
            // hate hate hate hate
            prefixIcon: Container(
              width: 48,
              height: 48,
              alignment: .center,
              child: results.connectionState == ConnectionState.waiting
                  ? const LoadingSpinner()
                  : const Iconify("magnifying-glass"),
            ),
            hintText: t.routes.search.search_hint,
            filled: true,
            fillColor: context.colors.mantle.withValues(
              alpha: SettingsDerived.transparency(0.75),
            ),
            border: const UnderlineInputBorder(borderRadius: .zero),
            enabledBorder: const UnderlineInputBorder(
              borderSide: .new(color: Colors.transparent),
              borderRadius: .zero,
            ),
          ),
        ),
        if (searchFuture.value != null)
          ...switch (results.data) {
            ApiSuccess(:final data) when data.list.isNotEmpty => [
              for (final artist in data.list) Text(artist.name),
            ],
            ApiSuccess() => [Text(t.routes.search.no_results)],
            ApiFailure(:final message) => [Text(message)],
            _ => _buildMainScreen(context),
          }
        else
          ..._buildMainScreen(context),
      ],
    );
  }

  List<Widget> _buildMainScreen(BuildContext context) {
    return [const Text("nothing searched")];
  }
}
