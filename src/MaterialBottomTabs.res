open Core
type layout = {"width": float, "height": float}
type options

module MaterialBottomTabNavigationProp = (
  M: {
    type params
    type options
  },
) => {
  include NavigationScreenProp(M)

  type t = navigation

  @send external jumpTo: (t, string) => unit = "jumpTo"
  @send
  external jumpToWithParams: (t, string, M.params) => unit = "jumpTo"
}

module Make = (
  M: {
    type params
  },
) => {
  type route = route<M.params>
  module Navigation = MaterialBottomTabNavigationProp({
    include M
    type options = options
  })

  type animatedNode = ReactNative.Animated.Value.t

  type scene = {"route": route, "focused": bool, "tintColor": string}

  type accessibilityRole = string
  type accessibilityStates = array<string>

  module TabBarBadge = {
    type t
    @val @module("./Interop")
    external t: @unwrap [#Bool(bool) | #Number(int) | #String(string)] => t = "identity"

    let boolean = x => t(#Bool(x))
    let number = x => t(#Number(x))
    let string = x => t(#String(x))
  }

  @obj
  external options: (
    ~title: string=?,
    ~tabBarColor: string=?,
    ~tabBarLabel: string=?,
    ~tabBarIcon: //TODO: dynamic, missing static option: React.ReactNode
    scene => React.element=?,
    ~tabBarBadge: TabBarBadge.t=?,
    ~tabBarAccessibilityLabel: string=?,
    ~tabBarTestID: string=?,
    unit,
  ) => options = ""

  type optionsProps = {
    navigation: navigation,
    route: route,
  }

  type optionsCallback = optionsProps => options

  type navigatorProps = {
    initialRouteName: option<string>,
    screenOptions: option<optionsCallback>,
    backBehavior: option<string>,
    shifting: option<bool>,
    labeled: option<bool>,
    activeColor: option<string>,
    inactiveColor: option<string>,
    barStyle: option<ReactNative.Style.t>,
  }

  type renderCallbackProp = {
    navigation: navigation,
    route: route,
  }

  type screenProps<'params> = {
    name: string,
    options: option<optionsCallback>,
    initialParams: option<'params>,
    component: option<React.component<{"navigation": navigation, "route": route}>>,
    children: option<renderCallbackProp => React.element>,
  }

  @module("@react-navigation/material-bottom-tabs")
  external make: unit => {
    "Navigator": navigatorProps => React.element,
    "Screen": screenProps<M.params> => React.element,
  } = "createMaterialBottomTabNavigator"

  let materialBottomTabs = make()

  module Screen = {
    @obj
    external makeProps: (
      ~name: string,
      ~options: optionsCallback=?,
      ~initialParams: M.params=?,
      ~component: React.component<{"navigation": navigation}>,
      ~key: string=?,
      unit,
    ) => screenProps<M.params> = ""
    let make = materialBottomTabs["Screen"]
  }

  module ScreenWithCallback = {
    @obj
    external makeProps: (
      ~name: string,
      ~options: optionsCallback=?,
      ~initialParams: M.params=?,
      ~children: renderCallbackProp => React.element,
      ~key: string=?,
      unit,
    ) => screenProps<M.params> = ""
    let make = materialBottomTabs["Screen"]
  }

  module Navigator = {
    @obj
    external makeProps: (
      ~initialRouteName: string=?,
      ~screenOptions: optionsCallback=?,
      ~children: React.element,
      ~backBehavior: [#initialRoute | #order | #history | #none]=?,
      ~shifting: bool=?,
      ~labeled: bool=?,
      ~activeColor: string=?,
      ~inactiveColor: string=?,
      ~barStyle: ReactNative.Style.t=?,
      ~key: //TODO: More? https://github.com/callstack/react-native-paper/blob/bd4296116d841ed355f3dbebb40cfbc3b87a79ff/src/components/BottomNavigation.tsx#L132-L196
      string=?,
      unit,
    ) => navigatorProps = ""

    let make = materialBottomTabs["Navigator"]
  }
}
