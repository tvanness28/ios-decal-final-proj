# EatWell

## Authors

- Timothy Van Ness

## Purpose

EatWell is an app that allows users to streamline the process of weekly meal
preperation by obfuscating all of the tedious conversions and calculations.

## Features

- Ability to store user data. (i.e. Daily calorie goal, meals per day, etc.)
- Ability to input and save nutritional information of foods.
- Ability to create recipes by proportion of types of food.
- Ability to include food/recipe/plan images.
- Ability to view food/recipe/plan nutrition statistics.
- Automated recipe/plan calculations given food info and user preferences.
- Ability to save and edit previous meal plans and recipes.
- Ability to favorite and delete recipes and meal plans.
- Ability to filter plans/recipes by food type, 

## Control Flow

- Initialize to a login prompt splash screen, if not already logged in.
- Continue to the main view where saved meal plans are presented to the user.
- The main view has a segmented control to switch between plans and recipes.
- An add new plan/recipe button will be located near the bottom of the view.
- Access to profile/filter setting are located in the navigation bar.
- Selecting a plan/recipe will take the user to a statistics view.
- Nutrition statistics will be presented in a user friendly graphical display.
- The statistics view will have an edit button in the navigation bar.
- The editing views are controlled by weighted scale sliders.
- Users will only enter exact values when adding new food items.
- Users can add new food items within the recipe editing view.

## Implementation

### Model

- User.Swift
- Food.Swift
- Recipe.Swift
- Plan.Swift

### View

- LoginView
- MainView
- PlanCollectionView
- RecipeCollectionView
- UserSettingsView
- FilterSettingsView
- FoodStatsView
- RecipeStatsView
- PlanStatsView
- FoodEditView
- RecipeEditView
- PlanEditView


### Controller

- LoginViewController
- MainViewController
- PlanCollectionViewController
- RecipeCollectionViewController
- UserSettingsViewController
- FilterSettingsViewController
- FoodStatsViewController
- RecipeStatsViewController
- PlanStatsViewController
- FoodEditViewController
- RecipeEditViewController
- PlanEditViewController
