import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lestari_admin/app/blocs/animals/animals_bloc.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/animals/animals_repository.dart';
import 'package:lestari_admin/data/models/animal_model.dart';
import 'package:lestari_admin/widgets/custom_animal_card.dart';
import 'package:lestari_admin/widgets/custom_loading.dart';
import 'package:sizer/sizer.dart';

class AnimalsPage extends StatefulWidget {
  const AnimalsPage({Key? key}) : super(key: key);

  @override
  State<AnimalsPage> createState() => _AnimalsPageState();
}

class _AnimalsPageState extends State<AnimalsPage> {
  bool _isSearching = false;
  late BuildContext _context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildSearchAppBar(),
      body: BlocProvider(
        create: (context) =>
        AnimalsBloc(RepositoryProvider.of<AnimalsRepository>(context))
          ..add(const GetAnimalsEvent()),
        child: RefreshIndicator(
          onRefresh: () async {
            await _refreshPage();
          },
          child: BlocBuilder<AnimalsBloc, AnimalsState>(
              builder: (context, state) {
                _context = context;
                if (state is AnimalsLoading) {
                  if (!_isSearching) {
                    return const CustomLoading();
                  } else {
                    _isSearching = false;
                    return const SizedBox.shrink();
                  }
                }
                if (state is AnimalsInitial) {
                  return const SizedBox.shrink();
                }
                if (state is AnimalsError) {
                  return Center(child: Text(state.message));
                }
                if (state is AnimalsLoaded) {
                  return _buildAnimalList(state.animalModels);
                }
                return Container();
              }
          ),
        ),
      ),
    );
  }

  Widget _buildAnimalList(List<AnimalModel> animalModels) {
    return GridView.builder(
      padding: SharedCode.defaultPagePadding,
      itemCount: animalModels.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 48.w / 43.h, mainAxisSpacing: 8.0, crossAxisSpacing: 4.0),
      itemBuilder: (BuildContext context, int index) {
        return CustomAnimalCard(animalModel: animalModels[index]);
      },
    );
  }

  Future<void> _refreshPage() async {
    BlocProvider.of<AnimalsBloc>(_context).add(const GetAnimalsEvent());
  }

  AppBar _buildSearchAppBar() {
    return SharedCode.buildSearchAppBar(context: context, searchHint: 'Cari hewan', title: 'List Hewan', onChanged: (s) {
      _isSearching = true;
      if (s == null || s.isEmpty) {
        _refreshPage();
      } else {
        BlocProvider.of<AnimalsBloc>(_context).add(SearchAnimalsEvent(s));
      }
    });
  }
}
