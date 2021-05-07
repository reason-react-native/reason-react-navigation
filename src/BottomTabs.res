open Core

type options

module BottomTabNavigationProp = (
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
  module Navigation = BottomTabNavigationProp({
    include M
    type options = options
  })

  type animatedNode = ReactNative.Animated.Value.t

  type scene = {
    index: int,
    focused: bool,
    tintColor: string,
  }

  type labelPositionArgs = {deviceOrientation: string}

  type baseBottomTabBarOptions = {
    "keyboardHidesTabBar": option<bool>,
    "activeBackgroundColor": option<string>,
    "inactiveBackgroundColor": option<string>,
    "allowFontScaling": option<bool>,
    "showLabel": option<bool>,
    "labelStyle": option<ReactNative.Style.t>,
    "tabStyle": option<ReactNative.Style.t>,
    "labelPosition": option<labelPositionArgs => string>,
    "adaptive": option<bool>,
    "style": option<ReactNative.Style.t>,
  }

  type bottomTabBarOptions = {
    ...baseBottomTabBarOptions,
    "activeTintColor": option<string>,
    "inactiveTintColor": option<string>,
  }

  type accessibilityRole = string
  type accessibilityStates = array<string>
  type routeArgs = {route: route}
  type renderIconArgs = {
    route: route,
    focused: bool,
    tintColor: string,
    horizontal: bool,
  }

  type bottomTabBarProps = {
    ...baseBottomTabBarOptions,
    "state": navigationState<M.params>,
    "navigation": navigation,
    "onTabPress": routeArgs => unit,
    "onTabLongPress": routeArgs => unit,
    "getAccessibilityLabel": routeArgs => Js.nullable<string>,
    "getAccessibilityRole": routeArgs => Js.nullable<accessibilityRole>,
    "getAccessibilityStates": routeArgs => Js.nullable<accessibilityStates>,
    "getButtonComponent": routeArgs => Js.nullable<React.element>,
    //"getLabelText" routeArgs => ...,
    "getTestID": routeArgs => Js.nullable<string>,
    "renderIcon": renderIconArgs => React.element,
    "activeTintColor": string,
    "inactiveTintColor": string,
  }

  type tabBarLabelArgs = {
    focused: bool,
    color: string,
  }
  type tabBarIconArgs = {
    focused: bool,
    color: string,
    size: float,
  }
  @obj
  external options: (
    ~title: string=?,
    ~tabBarLabel: //TODO: dynamic, missing static option: React.ReactNode
    tabBarLabelArgs => React.element=?,
    ~tabBarIcon: tabBarIconArgs => React.element=?,
    ~tabBarAccessibilityLabel: string=?,
    ~tabBarTestID: string=?,
    ~tabBarVisible: bool=?,
    ~tabBarButton: React.element=?,
    ~unmountOnBlur: bool=?,
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
    _lazy: option<bool>,
    tabBar: option<bottomTabBarOptions => React.element>,
    tabBarOptions: option<bottomTabBarOptions>,
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

  @module("@react-navigation/bottom-tabs")
  external make: unit => {
    "Navigator": navigatorProps => React.element,
    "Screen": screenProps<M.params> => React.element,
  } = "createBottomTabNavigator"

  let bottomTabs = make()

  module Screen = {
    @obj
    external makeProps: (
      ~name: string,
      ~options: optionsCallback=?,
      ~initialParams: M.params=?,
      ~component: React.component<{"navigation": navigation, "route": route}>,
      ~key: string=?,
      unit,
    ) => screenProps<M.params> = ""
    let make = bottomTabs["Screen"]
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
    let make = bottomTabs["Screen"]
  }

  module Navigator = {
    @obj
    external makeProps: (
      ~initialRouteName: string=?,
      ~screenOptions: optionsCallback=?,
      ~children: React.element,
      ~backBehavior: [#initialRoute | #order | #history | #none]=?,
      ~_lazy: bool=?,
      ~tabBar: bottomTabBarOptions => React.element=?,
      ~tabBarOptions: bottomTabBarOptions=?,
      ~key: string=?,
      unit,
    ) => navigatorProps = ""

    let make = bottomTabs["Navigator"]
  }
}
