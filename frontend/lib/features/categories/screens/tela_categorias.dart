import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/api_constants.dart';
import '../../../features/auth/providers/auth_provider.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/company_model.dart';
import '../../../features/home/widgets/card_empresa.dart';
import '../../../shared/widgets/shimmer_list.dart';
import '../../../core/theme/app_theme.dart';

part 'tela_categorias.g.dart';

@riverpod
Future<List<CategoryModel>> todasCategorias(TodasCategoriasRef ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get(ApiConstants.categorias);
  final list = response.data['dados'] as List;
  return list.map((e) => CategoryModel.fromJson(e as Map<String, dynamic>)).toList();
}

class TelaCategorias extends ConsumerWidget {
  const TelaCategorias({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriasAsync = ref.watch(todasCategoriasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Categorias')),
      body: categoriasAsync.when(
        data: (cats) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: cats.length,
          itemBuilder: (_, i) => _CategoriaCard(categoria: cats[i]),
        ),
        loading: () => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemCount: 9,
          itemBuilder: (_, __) => const ShimmerBox(height: 100),
        ),
        error: (_, __) => const Center(child: Text('Erro ao carregar categorias')),
      ),
    );
  }
}

class _CategoriaCard extends StatelessWidget {
  final CategoryModel categoria;

  const _CategoriaCard({required this.categoria});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/categorias/${categoria.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.15),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              categoria.icon ?? '🔧',
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              categoria.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
