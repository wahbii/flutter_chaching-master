part of '../home.dart';

class _HeaderSection extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final void Function(String?) onPressed;
  final void Function(String?) onSearch;


  _HeaderSection({
    required this.height,
    required this.onPressed,
    required this.onSearch
  });

  @override
  Size get preferredSize => Size.fromHeight(height);


  void _onThemeSwitcherPressed(BuildContext context) {
    final settingsBloc = context.read<SettingsBloc>();
    final currentTheme = settingsBloc.state.theme;

    settingsBloc.add(SettingsThemeChanged(
      currentTheme is LightAppTheme ? const DarkAppTheme() : const LightAppTheme(),
    ));
  }




  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);
    return FutureBuilder<List<CatGiveAway>>(
      future: homeProvider.getListCatGiveAway(), // async work
      builder: (BuildContext context, AsyncSnapshot<List<CatGiveAway>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return const Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return getHeader(context, snapshot.data);
            }
        }

      }
    );


  }

  Widget getHeader(BuildContext context , List<CatGiveAway>? data){
    return PokeballScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Transform.translate(
                offset: const Offset(-12, 0),
                child: SettingsThemeSelector(
                  builder: (theme) => ThemeSwitcherButton(
                    isDarkTheme: theme is DarkAppTheme,
                    onPressed: () => _onThemeSwitcherPressed(context),
                  ),
                ),
              ),
            //  const Spacer(),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:26),
                child: Text(
                  AppLocalizations.of(context)?.home_main_title ??"",
                  style: context.appTheme.typographies.headingLarge,
                ),
              ),
              AppSearchBar(
                hintText: AppLocalizations.of(context)?.hint_seash_home,
                onChanged: (input){
                      onSearch.call(input);
                },
              ),
              /*GridView(
                padding: const EdgeInsets.symmetric(vertical: 36),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.58,
                  mainAxisSpacing: 15,
                ),
                children:
                 data!.map((e) =>
                     _CategoryCard(
                   title: e.titleEng.toString(),
                   color: AppColors.listColors[Random().nextInt(AppColors.listColors.length-1)],
                   onPressed: () {
                     onPressed.call(e.id);

                   }
                      ),
                     ).toList()

                ,
              ),*/
            ],
          ),
        ),
      ),
    );
}
}
