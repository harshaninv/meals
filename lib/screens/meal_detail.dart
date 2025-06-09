import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:transparent_image/transparent_image.dart';

class MealDetailScreen extends ConsumerWidget {
  const MealDetailScreen({
    super.key,
    required this.meal,
    // required this. onToggleFavourite
  });

  final Meal meal;
  // final void Function(Meal meal) onToggleFavourite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteMeals = ref.watch(favoriteMealsProvider);

    final isFavorite = favouriteMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed:
                ()
                // => onToggleFavourite(meal),
                {
                  final wasAdded = ref
                      .read(favoriteMealsProvider.notifier)
                      .toggleMealFavouriteStatus(meal);

                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        wasAdded ? 'Meal added as a favorite' : 'Meal removed',
                      ),
                    ),
                  );
                },
            // icon: const Icon(Icons.star_outlined),
            // icon: Icon(isFavorite ? Icons.star : Icons.star_border),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(isFavorite ? Icons.star : Icons.star_border, key: ValueKey(isFavorite),),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  // turns: animation, 
                  turns: Tween(begin: 0.8, end: 1.0).animate(animation),
                  child: child
                );
              },

            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: meal.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(meal.imageUrl),
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 90, 38, 2),
                    Color.fromARGB(255, 136, 57, 0),
                    Color.fromARGB(255, 85, 40, 5),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    'Ingredients',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final ingredient in meal.ingredients)
                    Text(
                      ingredient,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              'Steps',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            // for (final step in meal.steps)
            for (int i = 0; i < meal.steps.length; i++)
              Padding(
                padding: EdgeInsetsGeometry.symmetric(
                  horizontal: 12,
                  vertical: 2,
                ),
                child: Text(
                  '${i + 1}. ${meal.steps[i]}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
