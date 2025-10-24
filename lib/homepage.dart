import 'package:flutter/material.dart';
import 'package:rec_app/recipedetailspage.dart';
import 'dart:ui'; // For image filter

// --- User class (can be moved to its own file later) ---
class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}

class Recipe {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> steps;
  final String category;
  final int cookTime;

  Recipe({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.category,
    required this.cookTime,
  });
}

class HomePage extends StatefulWidget {
  // It now requires a User object to be passed to it
  final User user;

  const HomePage({super.key, required this.user});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Recipe> _filteredRecipes;
  String _selectedCategory = 'All';
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final List<Recipe> _likedRecipes = [];
  bool _isShowingFavorites = false;

  late User _currentUser;

  @override
  void initState() {
    super.initState();

    // Use the user object passed from the login page
    _currentUser = widget.user;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _filteredRecipes = List.from(_recipes);
    _animationController.forward();

    _searchController.addListener(_updateFilteredList);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    _searchController.removeListener(_updateFilteredList);
    _searchController.dispose();
    super.dispose();
  }

  // --- UPDATED: New attractive image URLs for every recipe ---
  final List<Recipe> _recipes = [
    Recipe(
      title: 'Butter Chicken',
      description: 'A creamy and rich Indian chicken curry.',
      imageUrl: 'assets/images/butterchicken.png',
      ingredients: ['500g chicken', '1 cup tomato puree', '1/2 cup cream', '2 tbsp butter', 'Spices', 'Cashew paste'],
      steps: [
        'Marinate chicken pieces with yogurt, ginger-garlic paste, and spices.',
        'Let the chicken rest for at least 30 minutes to absorb flavors.',
        'Heat butter in a large pan and sauté finely chopped onions until golden.',
        'Add ginger-garlic paste and cook for another minute until fragrant.',
        'Stir in the tomato puree along with powdered spices like turmeric and red chili powder.',
        'Cook this gravy base until it thickens and oil starts to separate at the edges.',
        'Add the marinated chicken pieces and cook them thoroughly.',
        'Stir in cashew paste to give the gravy its characteristic richness and thickness.',
        'Finish by swirling in fresh cream and a pinch of sugar to balance the tanginess.',
        'Garnish with crushed kasuri methi (dried fenugreek leaves) and serve hot with naan.'
      ],
      category: 'Non-Veg',
      cookTime: 40,
    ),
    Recipe(
      title: 'Palak Paneer',
      description: 'Cottage cheese in a smooth spinach gravy.',
      imageUrl: 'assets/images/palakpaneer.png',
      ingredients: ['200g paneer', '1 bunch spinach', 'Onion', 'Garlic', 'Cream', 'Spices'],
      steps: [
        'Wash the spinach leaves thoroughly under running water.',
        'Blanch the spinach in boiling water for 2 minutes, then immediately transfer to ice-cold water.',
        'Blend the blanched spinach into a smooth, vibrant green puree.',
        'Cut the paneer into cubes and lightly pan-fry them in ghee until golden brown on all sides.',
        'In a separate pan, heat oil and sauté chopped onions until they turn golden.',
        'Add ginger-garlic paste and chopped tomatoes, cooking until the tomatoes are soft.',
        'Stir in powdered spices like turmeric, coriander, and a pinch of red chili powder.',
        'Pour in the spinach puree and cook the gravy for about 5-7 minutes.',
        'Gently add the fried paneer cubes to the spinach gravy.',
        'Finish with a drizzle of fresh cream and a sprinkle of garam masala before serving.'
      ],
      category: 'Veg',
      cookTime: 35,
    ),
    Recipe(
      title: 'Chocolate Brownie',
      description: 'A fudgy and dense chocolate baked dessert.',
      imageUrl: 'assets/images/chocolatebrownie.png',
      ingredients: ['1/2 cup butter', '1 cup sugar', '2 eggs', '1/2 cup flour', '1/3 cup cocoa powder', 'Chocolate chips'],
      steps: [
        'Preheat your oven to 175°C (350°F).',
        'Grease and flour an 8-inch square baking pan for easy removal.',
        'In a large saucepan, melt the butter and sugar together over low heat.',
        'Remove the pan from the heat and allow the mixture to cool slightly.',
        'Whisk in the eggs one at a time, mixing well after each addition.',
        'In a separate bowl, sift together the flour, cocoa powder, and a pinch of salt.',
        'Gently fold the dry ingredients into the wet mixture until just combined; do not overmix.',
        'Stir in your desired amount of chocolate chips.',
        'Pour the final batter into the prepared pan and spread evenly.',
        'Bake for 25-30 minutes, or until a toothpick inserted in the center comes out with moist crumbs.'
      ],
      category: 'Sweets',
      cookTime: 35,
    ),
    Recipe(
      title: 'Tandoori Chicken',
      description: 'Smoky grilled chicken marinated in yogurt and spices.',
      imageUrl: 'assets/images/tandoorichicken.png',
      ingredients: ['1 kg chicken', '1 cup yogurt', 'Tandoori masala', 'Ginger-garlic paste', 'Lemon juice'],
      steps: [
        'Clean the chicken pieces and make deep gashes in them with a knife.',
        'Apply a first marinade of lemon juice, salt, and red chili powder, rubbing it into the gashes.',
        'For the second marinade, whisk thick yogurt with tandoori masala, and ginger-garlic paste.',
        'Thoroughly coat the chicken pieces in this second yogurt marinade.',
        'Let the chicken marinate in the refrigerator for at least 4-6 hours, or preferably overnight.',
        'Preheat your oven or grill to a high temperature, around 200°C (400°F).',
        'Thread the marinated chicken pieces onto skewers.',
        'Grill for 20-25 minutes, turning the skewers occasionally for even cooking.',
        'During the last 10 minutes of grilling, baste the chicken with butter or oil.',
        'Serve hot, garnished with onion rings and a side of fresh mint chutney.'
      ],
      category: 'Non-Veg',
      cookTime: 50,
    ),
    Recipe(
      title: 'Chana Masala',
      description: 'A popular chickpea curry from North India.',
      imageUrl: 'assets/images/chanamasala.png',
      ingredients: ['1 can chickpeas', '2 onions', '3 tomatoes', 'Ginger-garlic paste', 'Chana masala powder'],
      steps: [
        'If using dried chickpeas, soak them overnight and boil until soft. Otherwise, use canned chickpeas.',
        'Heat oil in a pan and temper with a teaspoon of cumin seeds.',
        'Add finely chopped onions and sauté until they are golden brown.',
        'Stir in ginger-garlic paste and finely chopped green chilies.',
        'Add pureed tomatoes and cook until the masala thickens and releases oil.',
        'Add dry spices: turmeric, red chili powder, and a generous amount of chana masala powder.',
        'Add the boiled or canned chickpeas to the gravy and mix well.',
        'Lightly mash some of the chickpeas with the back of a spoon to thicken the curry.',
        'Add water to adjust consistency and simmer for 10-15 minutes.',
        'Garnish with fresh cilantro leaves and a squeeze of lemon juice before serving.'
      ],
      category: 'Veg',
      cookTime: 30,
    ),
    Recipe(
      title: 'Chicken Biryani',
      description: 'Aromatic rice dish with spiced chicken.',
      imageUrl: 'assets/images/chickenbiryani.png',
      ingredients: ['500g chicken', '2 cups basmati rice', 'Yogurt', 'Onions', 'Biryani masala'],
      steps: [
        'Wash and soak the basmati rice for at least 30 minutes.',
        'Marinate the chicken pieces in yogurt, biryani masala, and fried onions for an hour.',
        'In a large pot, bring water to a boil with whole spices and salt.',
        'Cook the soaked rice in the boiling water until it is 70% cooked, then drain.',
        'In a heavy-bottomed pot, spread the marinated chicken in an even layer.',
        'Top the chicken with a layer of the partially cooked rice.',
        'Sprinkle saffron-infused milk, fresh mint leaves, and more fried onions over the rice.',
        'If using, create another alternating layer of chicken and rice.',
        'Seal the pot with a tight-fitting lid and dough to trap the steam.',
        'Cook on a very low heat (dum) for about 25-30 minutes, then let it rest before opening.'
      ],
      category: 'Non-Veg',
      cookTime: 60,
    ),
    Recipe(
      title: 'Classic Pancakes',
      description: 'Fluffy pancakes for a perfect breakfast.',
      imageUrl: 'assets/images/pancakes.png',
      ingredients: ['1 1/2 cups flour', '3 1/2 tsp baking powder', '1 tsp salt', '1 tbsp sugar', '1 1/4 cups milk', '1 egg', '3 tbsp melted butter'],
      steps: [
        'In a large bowl, sift or whisk together the flour, baking powder, salt, and sugar.',
        'Create a well in the center of your dry ingredients.',
        'In a separate, smaller bowl, lightly whisk the egg and then stir in the milk.',
        'Melt the butter in a microwave or on the stovetop and let it cool for a minute.',
        'Pour the milk and egg mixture into the well of the dry ingredients.',
        'Add the slightly cooled melted butter to the bowl.',
        'Whisk the batter until it is just smooth; a few small lumps are okay. Do not overmix.',
        'Let the prepared batter rest for 5 to 10 minutes. This allows the gluten to relax.',
        'Heat a non-stick griddle or frying pan over medium-high heat and lightly oil it.',
        'Pour about 1/4 cup of batter for each pancake and cook until bubbles appear on the surface, then flip and cook the other side until golden.'
      ],
      category: 'Veg',
      cookTime: 20,
    ),
    Recipe(
      title: 'Gulab Jamun',
      description: 'Soft, melt-in-your-mouth milk-solid balls in syrup.',
      imageUrl: 'assets/images/gulabjamun.png',
      ingredients: ['1 cup milk powder', '1/4 cup flour', 'Ghee', 'Sugar', 'Cardamom'],
      steps: [
        'First, prepare the sugar syrup by boiling sugar and water with a few crushed cardamom pods.',
        'In a mixing bowl, combine the milk powder, all-purpose flour, and a pinch of baking soda.',
        'Add a tablespoon of ghee to the dry mixture and crumble it with your fingertips.',
        'Gradually add milk or cream to form a soft, smooth dough. Do not knead it excessively.',
        'Let the dough rest for 5 minutes.',
        'Grease your palms and divide the dough into small, smooth, crack-free balls.',
        'Heat ghee or oil in a deep pan over a low flame.',
        'Fry the balls on a consistent low heat, stirring gently, until they are evenly golden brown.',
        'Remove the fried balls and let them cool for a minute before dropping them into the warm (not boiling) sugar syrup.',
        'Allow the gulab jamuns to soak in the syrup for at least 1-2 hours before serving.'
      ],
      category: 'Sweets',
      cookTime: 45,
    ),
    Recipe(
      title: 'Mutton Rogan Josh',
      description: 'A fragrant lamb curry from Kashmiri cuisine.',
      imageUrl: 'assets/images/muttonroganjosh.png',
      ingredients: ['500g mutton', 'Yogurt', 'Onions', 'Kashmiri red chili', 'Fennel powder'],
      steps: [
        'Heat ghee or mustard oil in a heavy-bottomed pot or pressure cooker.',
        'Temper the hot oil with whole spices like cinnamon, cloves, bay leaves, and cardamom.',
        'Add thinly sliced onions and fry them until they are a deep golden brown.',
        'Add the mutton pieces and sear them on high heat until browned on all sides.',
        'In a bowl, whisk yogurt with Kashmiri red chili powder and fennel seed powder.',
        'Lower the heat completely and slowly add the spiced yogurt mixture to the pot.',
        'Stir continuously for a few minutes to prevent the yogurt from curdling.',
        'Add ginger powder (sonth) and other ground spices, then sauté for a few minutes.',
        'Add water, season with salt, and pressure cook for about 6-8 whistles until the mutton is tender.',
        'Once cooked, let the pressure release naturally. Simmer for a few more minutes to adjust the gravy consistency.'
      ],
      category: 'Non-Veg',
      cookTime: 90,
    ),
    Recipe(
      title: 'Aloo Gobi',
      description: 'A simple potato & cauliflower stir-fry.',
      imageUrl: 'assets/images/alooogobi.png',
      ingredients: ['2 potatoes', '1 cauliflower', 'Turmeric', 'Cumin seeds', 'Spices'],
      steps: [
        'Wash and chop the potatoes into cubes and the cauliflower into medium-sized florets.',
        'Heat oil in a wide pan or kadai and add a teaspoon of cumin seeds.',
        'Once the cumin seeds begin to splutter, add finely chopped onions and sauté until translucent.',
        'Stir in ginger-garlic paste and cook for one minute until the raw smell disappears.',
        'Add the potato cubes and cauliflower florets to the pan.',
        'Sprinkle over the powdered spices: turmeric, red chili powder, and coriander powder.',
        'Mix everything well, ensuring the vegetables are evenly coated with the spices.',
        'Cover the pan with a lid and cook on a low to medium flame.',
        'Stir occasionally to prevent sticking, and cook until the vegetables are tender.',
        'Garnish with a sprinkle of garam masala and freshly chopped cilantro before serving.'
      ],
      category: 'Veg',
      cookTime: 25,
    ),
    Recipe(
      title: 'Fish Curry',
      description: 'A tangy and spicy fish curry with coconut milk.',
      imageUrl: 'assets/images/fishcurry.png',
      ingredients: ['500g fish fillets', 'Coconut milk', 'Tamarind paste', 'Onions', 'Mustard seeds'],
      steps: [
        'Lightly marinate the fish fillets with turmeric powder and salt for 15 minutes.',
        'Heat oil in a pan and temper with mustard seeds, fenugreek seeds, and curry leaves.',
        'Add finely chopped onions and sauté until they become soft and translucent.',
        'Stir in ginger-garlic paste and cook until fragrant.',
        'Add tomato puree and cook the masala base until oil starts to separate.',
        'Pour in thin coconut milk and bring the curry to a gentle simmer.',
        'Add tamarind paste for a tangy flavor, along with salt and red chili powder.',
        'Gently slide the marinated fish fillets into the simmering curry.',
        'Cook for 5-7 minutes, or until the fish is cooked through. Avoid over-stirring.',
        'Finish by pouring in thick coconut milk and turning off the heat. Garnish with cilantro.'
      ],
      category: 'Non-Veg',
      cookTime: 30,
    ),
    Recipe(
      title: 'Veggie Delight Pizza',
      description: 'A delicious pizza loaded with fresh vegetables.',
      imageUrl: 'assets/images/pizza.png',
      ingredients: ['Pizza base', 'Marinara sauce', 'Mozzarella cheese', 'Bell peppers', 'Onions', 'Olives', 'Mushrooms'],
      steps: [
        'Preheat your oven to the temperature specified on the pizza base package, usually around 220°C (425°F).',
        'Place the pizza base on a baking tray or pizza stone.',
        'Using the back of a spoon, spread a generous and even layer of marinara or pizza sauce.',
        'Sprinkle a thick layer of shredded mozzarella cheese, covering the sauce completely.',
        'Evenly distribute your chopped vegetables: bell peppers, onions, and black olives.',
        'Add sliced mushrooms over the top for an extra layer of flavor.',
        'Season the pizza with a sprinkle of dried oregano and red chili flakes.',
        'Optionally, drizzle a small amount of olive oil over the toppings.',
        'Bake for 12-15 minutes, or until the crust is golden brown and the cheese is bubbly and melted.',
        'Carefully remove from the oven, let it cool for a minute, then slice and serve hot.'
      ],
      category: 'Veg',
      cookTime: 20,
    ),
    Recipe(
      title: 'Gajar Ka Halwa',
      description: 'A sweet carrot pudding, a winter delicacy.',
      imageUrl: 'assets/images/gajar.png',
      ingredients: ['1 kg carrots', '1 liter milk', '1 cup sugar', 'Ghee', 'Nuts'],
      steps: [
        'Thoroughly wash, peel, and finely grate the carrots.',
        'In a large, heavy-bottomed pan, combine the grated carrots and milk.',
        'Bring the mixture to a boil over medium-high heat.',
        'Once boiling, reduce the heat to medium and continue to simmer.',
        'Cook, stirring frequently to prevent sticking, until all the milk has been absorbed by the carrots.',
        'When the milk has evaporated, add the sugar and mix well.',
        'The halwa will become watery again as the sugar melts; continue to cook.',
        'Add ghee to the pan and cook, stirring continuously, until the halwa thickens and darkens in color.',
        'Stir in powdered cardamom and your choice of chopped nuts like almonds and cashews.',
        'Serve the Gajar Ka Halwa hot, garnished with extra nuts.'
      ],
      category: 'Sweets',
      cookTime: 60,
    ),
    Recipe(
      title: 'Chocolate Lava Cake',
      description: 'A rich and decadent dessert.',
      imageUrl: 'assets/images/lavacake.png',
      ingredients: ['100g dark chocolate', '100g butter', '2 eggs', '2 egg yolks', '60g sugar', '30g flour'],
      steps: [
        'Preheat your oven to 220°C (425°F) and generously grease two small ramekins.',
        'Melt the dark chocolate and butter together, either in a microwave or over a double boiler.',
        'In a separate bowl, use an electric mixer to whisk the eggs, egg yolks, and sugar until pale and thick.',
        'Gently pour the slightly cooled, melted chocolate mixture into the egg mixture.',
        'Sift in the flour and a pinch of salt over the batter.',
        'Carefully fold everything together with a spatula until just combined. Do not overmix.',
        'Evenly divide the batter between the two prepared ramekins.',
        'Place the ramekins on a baking sheet and bake for exactly 12-14 minutes.',
        'The edges of the cake should be firm, but the center will still be soft and gooey.',
        'Let the cakes cool in the ramekins for one minute, then carefully invert them onto serving plates.'
      ],
      category: 'Sweets',
      cookTime: 22,
    ),
  ];

  void _updateFilteredList() {
    List<Recipe> tempFilteredList = List.from(_recipes);

    if (_selectedCategory != 'All') {
      tempFilteredList = tempFilteredList
          .where((recipe) => recipe.category == _selectedCategory)
          .toList();
    }

    final searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      tempFilteredList = tempFilteredList
          .where((recipe) => recipe.title.toLowerCase().contains(searchQuery))
          .toList();
    }

    setState(() {
      _isShowingFavorites = false;
      _filteredRecipes = tempFilteredList;
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _updateFilteredList();
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      setState(() {
        _isShowingFavorites = false;
        _isSearching = !_isSearching;
        if (!_isSearching) {
          _searchController.clear();
        }
      });
      return;
    }

    if (_isSearching) {
      setState(() {
        _isSearching = false;
        _searchController.clear();
      });
    }

    if (index == 0 && _isShowingFavorites) {
      setState(() {
        _isShowingFavorites = false;
        _animationController.reset();
        _animationController.forward();
      });
    }

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        if (_scrollController.offset > 0) {
          _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
        break;
      case 2:
        _showAddRecipeDialog();
        break;
      case 3:
        _scaffoldKey.currentState?.openDrawer();
        break;
    }
  }

  void _showAddRecipeDialog() {
    final titleController = TextEditingController();
    final ingredientsController = TextEditingController();
    final stepsController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Your Recipe"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Recipe Title",
                    labelText: "Title",
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: ingredientsController,
                  decoration: const InputDecoration(
                    hintText: "List ingredients, separated by commas",
                    labelText: "Ingredients",
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: stepsController,
                  decoration: const InputDecoration(
                    hintText: "List steps, one per line",
                    labelText: "Steps",
                  ),
                  maxLines: 6,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Submit"),
              onPressed: () {
                Navigator.of(context).pop();
                _showSubmissionConfirmationDialog();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSubmissionConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submission Received"),
          content: const Text(
              "Thank you for sharing your recipe with us! Our team will review it, and if it's a good fit, we'll feature it in the app."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleLike(Recipe recipe) {
    setState(() {
      if (_likedRecipes.contains(recipe)) {
        _likedRecipes.remove(recipe);
      } else {
        _likedRecipes.add(recipe);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      appBar: AppBar(
        title: _isShowingFavorites
            ? const Text('My Favorites', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${_currentUser.name} 👋',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const Text(
              'What are you cooking today?',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.grey[800]),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: _buildAppDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.05),
                  Colors.grey.shade50,
                  Colors.white,
                ],
              ),
            ),
          ),
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.15),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
            child: Container(
              color: Colors.transparent,
            ),
          ),
          _isShowingFavorites ? _buildFavoritesView() : _buildMainContentView(),
        ],
      ),
      bottomNavigationBar: _buildFloatingNavigationBar(),
    );
  }

  Widget _buildAppDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              _currentUser.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            accountEmail: Text(_currentUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                _currentUser.name.isNotEmpty ? _currentUser.name[0].toUpperCase() : "",
                style: const TextStyle(fontSize: 40.0, color: Colors.orange),
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: const Text('My Favorites'),
            onTap: () {
              Navigator.pop(context);
              setState(() {
                _isShowingFavorites = true;
                _animationController.reset();
                _animationController.forward();
              });
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings page coming soon!')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainContentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterChips(),
        _buildSearchBar(),
        Expanded(
          child: _filteredRecipes.isEmpty
              ? _buildNoResultsWidget()
              : ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 100.0),
            itemCount: _filteredRecipes.length,
            itemBuilder: (context, index) {
              final recipe = _filteredRecipes[index];
              final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _animationController,
                  curve: Interval(
                    (1 / _filteredRecipes.length) * index,
                    1.0,
                    curve: Curves.easeOut,
                  ),
                ),
              );
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: _buildRecipeCard(recipe),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesView() {
    if (_likedRecipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'No Favorites Yet',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                'Tap the heart on any recipe to add it to your favorites.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 100.0),
      itemCount: _likedRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _likedRecipes[index];
        final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(
              (1 / _likedRecipes.length) * index,
              1.0,
              curve: Curves.easeOut,
            ),
          ),
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: _buildRecipeCard(recipe),
          ),
        );
      },
    );
  }

  Widget _buildFloatingNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Add',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey[600],
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final categories = ['All', 'Veg', 'Non-Veg', 'Sweets'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ChoiceChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  _onCategorySelected(category);
                }
              },
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
              backgroundColor: Colors.white,
              selectedColor: Theme.of(context).primaryColor,
              shape: StadiumBorder(
                side: BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
              ),
              elevation: 3,
              pressElevation: 5,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: _isSearching
          ? Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
        child: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search recipes...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
              },
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No Recipes Found',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Try searching for something else or adjusting your filters.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    final isLiked = _likedRecipes.contains(recipe);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailPage(recipe: recipe)
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Hero(
            //   tag: 'recipeImage-${recipe.title}',
            //   child: Image.network(
            //     recipe.imageUrl,
            //     height: 220,
            //     width: double.infinity,
            //     fit: BoxFit.cover,
            //     errorBuilder: (context, error, stackTrace) => Container(
            //       height: 220,
            //       color: Colors.grey[300],
            //       child: Icon(Icons.broken_image, size: 40, color: Colors.grey[600]),
            //     ),
            //   ),
            // ),
            Hero(
              tag: 'recipeImage-${recipe.title}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 16 / 9, // You can adjust to match your images
                  child: Image.network(
                    recipe.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[00],
                      child: Icon(Icons.broken_image, size: 40, color: Colors.grey[300]),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 2.0, color: Colors.black54)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          recipe.category,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${recipe.cookTime} min',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.4),
                ),
                child: IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    _toggleLike(recipe);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


