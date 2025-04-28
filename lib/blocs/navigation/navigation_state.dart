abstract class NavigationState {
  final int index;
  const NavigationState(this.index);
}

class NavigationInitial extends NavigationState {
  const NavigationInitial() : super(0);
}

class NavigationTabState extends NavigationState {
  const NavigationTabState(int index) : super(index);
}