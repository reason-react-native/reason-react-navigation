open Core

type layout = {
  width: float,
  height: float,
}
type options

module MaterialTopTabNavigationProp = (
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
  module Navigation = MaterialTopTabNavigationProp({
    include M
    type options = options
  })

  type animatedNode = ReactNative.Animated.Value.t

  type scene = {
    focused: bool,
    color: string,
  }

  type descriptors

  type tabBar = {
    "scrollEnabled": option<bool>,
    //pub navigationState: navigationState(M.params);
    //pub activeColor: option(string);
    //pub inactiveColor: option(string);
    "pressColor": option<string>,
    "pressOpacity": option<float>,
    //TODO: render: https://github.com/react-native-community/react-native-tab-view/blob/64e03bf14b0fac9c3bccd684bf31a04ecf19c50d/src/TabBar.tsx#L38-L51
    "tabStyle": option<ReactNative.Style.t>,
    "indicatorStyle": option<ReactNative.Style.t>,
    "labelStyle": option<ReactNative.Style.t>,
    "style": option<ReactNative.Style.t>,
    "renderIndicator": option<React.component<{"route": route}>>,
  }

  type materialTopTabBarOptions = {
    ...tabBar,
    "activeTintColor": option<string>,
    "inactiveTintColor": option<string>,
    "iconStyle": option<ReactNative.Style.t>,
    "showLabel": option<bool>,
    "showIcon": option<bool>,
    "allowFontScaling": option<bool>,
  }

  type accessibilityRole = string
  type accessibilityStates = array<string>

  type routeOptions = {route: route}

  type materialTopTabBarProps = {
    ...materialTopTabBarOptions,
    "state": navigationState<M.params>,
    "navigation": navigation,
    "descriptors": descriptors,
    // SceneRendererProps from react-native-tab-view
    "layout": layout,
    "position": animatedNode,
    "jumpTo": string => unit,
  }

  @obj
  external options: (
    ~title: string=?,
    ~tabBarLabel: //TODO: dynamic, missing static option: React.ReactNode
    scene => React.element=?,
    ~tabBarIcon: //TODO: dynamic, missing static option: React.ReactNode
    scene => React.element=?,
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
    _lazy: option<bool>,
    lazyPreloadDistance: option<int>,
    lazyPlaceholder: option<React.component<{"route": route}>>,
    tabBar: option<materialTopTabBarProps => React.element>,
    tabBarOptions: option<materialTopTabBarOptions>,
    tabBarPosition: option<string>,
    backBehavior: option<string>,
    removeClippedSubviews: option<bool>,
    keyboardDismissMode: option<string>,
    swipeEnabled: option<bool>,
    swipeVelocityImpact: option<float>,
    sceneContainerStyle: option<ReactNative.Style.t>,
    style: option<ReactNative.Style.t>,
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

  @module("@react-navigation/material-top-tabs")
  external make: unit => {
    "Navigator": navigatorProps => React.element,
    "Screen": screenProps<M.params> => React.element,
  } = "createMaterialTopTabNavigator"

  let materialTopTabs = make()

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
    let make = materialTopTabs["Screen"]
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
    let make = materialTopTabs["Screen"]
  }

  module Navigator = {
    @obj
    external makeProps: (
      ~initialRouteName: string=?,
      ~screenOptions: optionsCallback=?,
      ~children: React.element,
      ~backBehavior: [#initialRoute | #order | #history | #none]=?,
      ~_lazy: bool=?,
      ~lazyPreloadDistance: int=?,
      ~lazyPlaceholder: React.component<{"route": route}>=?,
      ~tabBar: materialTopTabBarProps => React.element=?,
      ~tabBarOptions: materialTopTabBarOptions=?,
      ~tabBarPosition: [#top | #bottom]=?,
      ~removeClippedSubviews: bool=?,
      ~keyboardDismissMode: @string
      [
        | #auto
        | @as("on-drag") #onDrag
        | #none
      ]=?,
      ~swipeEnabled: bool=?,
      ~swipeVelocityImpact: float=?,
      ~sceneContainerStyle: ReactNative.Style.t=?,
      ~style: ReactNative.Style.t=?,
      ~key: string=?,
      unit,
    ) => navigatorProps = ""

    let make = materialTopTabs["Navigator"]
  }

  module MaterialTopTabBar = {
    @module("@react-navigation/material-top-tabs") @react.component
    external make: (
      ~state: navigationState<M.params>,
      ~navigation: navigation,
      ~descriptors: descriptors,
      ~layout: // SceneRendererProps from react-native-tab-view
      layout,
      ~position: animatedNode,
      ~jumpTo: string => unit,
      ~activeTintColor: // materialTopTabBarOptions
      string=?,
      ~inactiveTintColor: string=?,
      ~iconStyle: ReactNative.Style.t=?,
      ~showLabel: bool=?,
      ~showIcon: bool=?,
      ~allowFontScaling: bool=?,
      ~scrollEnabled: bool=?,
      ~pressColor: string=?,
      ~pressOpacity: float=?,
      ~tabStyle: ReactNative.Style.t=?,
      ~indicatorStyle: ReactNative.Style.t=?,
      ~labelStyle: ReactNative.Style.t=?,
      ~style: ReactNative.Style.t=?,
      ~renderIndicator: React.component<{"route": route}>=?,
      unit,
    ) => React.element = "MaterialTopTabBar"
  }
}
