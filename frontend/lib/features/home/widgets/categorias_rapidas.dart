import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/category_model.dart';
import '../../../core/theme/app_theme.dart';

class CategoriasRapidas extends StatelessWidget {
  final List<CategoryModel> categorias;

  const CategoriasRapidas({super.key, required this.categorias});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _CategoriaChip(categoria: categorias[i]),
      ),
    );
  }
}

class _CategoriaChip extends StatelessWidget {
  final CategoryModel categoria;

  const _CategoriaChip({required this.categoria});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/categorias/${categoria.id}'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                categoria.icon ?? '🔧',
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 64,
            child: Text(
              categoria.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption,
            ),
          ),
        ],
      ),
    );
  }
}
