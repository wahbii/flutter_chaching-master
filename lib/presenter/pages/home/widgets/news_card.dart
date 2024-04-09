part of '../home.dart';

class _NewsListTile extends StatelessWidget {
  final Uint8List bytes;
  final String title;
  final DateTime time;
  final String participant;
  final String desc;

  final String id;
  final Function(String id) oncllick;

  const _NewsListTile(
      {required this.title,
      required this.time,
      required this.bytes,
      required this.desc,
      required this.oncllick,
      required this.participant,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            padding: EdgeInsets.all(20),
            decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: InkWell(
              onTap: () {
                oncllick.call(id);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          title.capitalize(),
                          style: context.typographies.body
                              .withWeight(FontWeight.bold)
                              .withSize(20),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "$desc",
                          style: context.typographies.bodyExtraSmall
                              .withColor(AppColors.grey)
                              .withWeight(FontWeight.w400),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        (time.difference(DateTime.now()).isNegative)
                            ? Text(
                                AppLocalizations.of(context)?.key_fineshed_tombola??"",
                                style: context.typographies.body
                                    .withColor(AppColors.lightGreen)
                                    .withWeight(FontWeight.w500).withSize(14),
                                    
                              )
                            : SlideCountdown(
                                duration: Duration(
                                  days: time.difference(DateTime.now()).inDays,
                                  hours:
                                      time.difference(DateTime.now()).inHours,
                                  minutes:
                                      time.difference(DateTime.now()).inMinutes,
                                  seconds:
                                      time.difference(DateTime.now()).inSeconds,
                                ),
                              ),

                        /*Text(
                time,
                style: context.typographies.caption.withColor(context.colors.hint),
              ),*/
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                      ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            bytes,
                            width: 180,
                            height: 120,
                            fit: BoxFit.cover,
                          )),
                ],
              ),
            )),
        Positioned(
          top: 0,
          right: 20,
          child: Container(
              decoration: const BoxDecoration(
                  color: AppColors.paarl_lite,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              height: 15,
              width: 100,
              child: Center(
                child: Text(
                  "${AppLocalizations.of(context)?.participant ?? ""} : $participant",
                  style: context.typographies.bodySmall
                      .withColor(AppColors.white)
                      .withSize(10)
                      .withWeight(FontWeight.w600),
                ),
              )),
        )
      ],
    );
  }
}
