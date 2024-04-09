part of '../home.dart';

class _NewsSection extends StatelessWidget {
  List<GiveAway> data = [];

  _NewsSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return getListGiveAways(context, data);
  }

  Widget getListGiveAways(BuildContext context, List<GiveAway> data) {
    return data.isEmpty
        ? Center(
            child: Text(AppLocalizations.of(context)?.giveaways_err ?? ""),
          )
        : ListView(
            physics: const ClampingScrollPhysics(),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 10),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.giveaways ?? "",
                    style: context.typographies.headingSmall,
                  ),
                ],
              ),
              ListView.separated(
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                separatorBuilder: (_, __) => const Divider(height: 30),
                itemBuilder: (_, int index) {
                  return _NewsListTile(
                    id: data[index].id,
                    title: PokedexApp.of(context)?.local == Locale("ar")
                        ? data[index].titleAr
                        : (PokedexApp.of(context)?.local == Locale("fr")
                            ? data[index].titleFr
                            : data[index].titleEng),
                    desc: PokedexApp.of(context)?.local == Locale("ar")
                        ? data[index].descAr
                        : (PokedexApp.of(context)?.local == Locale("fr")
                        ? data[index].descFr
                        : data[index].descEng),
                    time: data[index].dateRest.toDate(),
                    bytes: base64Decode(data[index].img),
                    participant: data[index].commandesId.length.toString(),
                    oncllick: (id) {
                      var diff = data[index]
                          .dateRest
                          .toDate()
                          .difference(DateTime.now());
                      if (diff.isNegative) {
                        context.router.push(WinnerRoute(
                            idVideo: data[index].Url,
                            jetons: data[index].idWinner));
                      } else {
                        context.router
                            .push(ProductListRoute(idGiveAway: data[index].id));
                      }
                      //
                    },
                  );
                },
              ),
            ],
          );
  }
}
