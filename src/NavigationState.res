type rec t = {
  index: int,
  routeName: string,
  routes: option<array<t>>,
  isDrawerOpen: bool,
}

type persistNavigationState = t => Js.Promise.t<unit>
type loadNavigationState = unit => Js.Promise.t<option<t>>
