type action

type navigateParams

@obj
external navigateParams: (~routeName: string, ~params: {..}=?, unit) => navigateParams = ""

type backParams

@obj
external backParams: (~key: string=?, ~immediate: bool=?, unit) => navigateParams = ""

@module("react-navigation") @scope("NavigationActions")
external navigate: navigateParams => action = "navigate"

@module("react-navigation") @scope("NavigationActions")
external back: backParams => action = "back"
