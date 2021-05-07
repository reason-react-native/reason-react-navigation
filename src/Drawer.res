open Core

type options

module DrawerNavigationProp = (
  M: {
    type params
    type options
  },
) => {
  include NavigationScreenProp(M)

  type t = navigation

  @send external openDrawer: t => unit = "openDrawer"
  @send external closeDrawer: t => unit = "closeDrawer"
  @send external toggleDrawer: t => unit = "toggleDrawer"
}

module Make = (
  M: {
    type params
  },
) => {
  module Navigation = DrawerNavigationProp({
    include M
    type options = options
  })

  type animatedNode = ReactNative.Animated.Value.t

  type scene = {
    route: route<M.params>,
    index: int,
    focused: bool,
    tintColor: option<string>,
  }

  type contentOptions = {
    "items": array<route<M.params>>,
    "activeItemKey": option<Js.nullable<string>>,
    "activeTintColor": option<string>,
    "activeBackgroundColor": option<string>,
    "inactiveTintColor": option<string>,
    "inactiveBackgroundColor": option<string>,
    "itemsContainerStyle": option<ReactNative.Style.t>,
    "itemStyle": option<ReactNative.Style.t>,
    "labelStyle": option<ReactNative.Style.t>,
    "activeLabelStyle": option<ReactNative.Style.t>,
    "inactiveLabelStyle": option<ReactNative.Style.t>,
    "iconContainerStyle": option<ReactNative.Style.t>,
  }

  type drawerNavigationItemsProps = {
    ...contentOptions,
    "drawerPosition": string,
    "getLabel": scene => React.element,
    "renderIcon": scene => React.element,
    "onItemPress": scene => unit,
  }

  type contentComponentProps = {
    ...drawerNavigationItemsProps,
    "navigation": navigation,
    "drawerOpenProgress": animatedNode,
  }

  @obj
  external options: (
    ~title: string=?,
    ~drawerLabel: scene => React.element=?,
    ~drawerIcon: scene => React.element=?,
    ~drawerLockMode: @string
    [
      | #unlocked
      | @as("locked-closed") #lockedClosed
      | @as("locked-open") #lockedOpen
    ]=?,
    unit,
  ) => options = ""

  type optionsProps = {
    navigation: navigation,
    route: route<M.params>,
  }

  type optionsCallback = optionsProps => options

  type navigatorProps

  type screenProps

  @module("@react-navigation/drawer")
  external make: unit => {
    "Navigator": navigatorProps => React.element,
    "Screen": screenProps => React.element,
  } = "createDrawerNavigator"

  let stack = make()

  module Screen = {
    @obj
    external makeProps: (
      ~name: string,
      ~options: optionsCallback=?,
      ~initialParams: M.params=?,
      ~component: React.component<{"navigation": navigation, "route": route<M.params>}>,
      ~key: string=?,
      unit,
    ) => screenProps = ""
    let make = stack["Screen"]
  }

  module Navigator = {
    @obj
    external makeProps: (
      ~initialRouteName: string=?,
      ~screenOptions: optionsCallback=?,
      ~children: React.element,
      ~backBehavior: [#initialRoute | #order | #history | #none]=?,
      ~drawerBackgroundColor: //DrawerNavigationConfig
      string=?,
      ~drawerPosition: [#left | #right]=?,
      ~drawerType: [#front | #back | #slide | #permanent]=?,
      ~drawerWidth: /*
         ~drawerWidth: [@bs.unwrap] [
                         | `Static(float)
                         | `Dynamic(unit => float)
                       ]

 */
      unit => float,
      ~edgeWidth: float=?,
      ~hideStatusBar: bool=?,
      ~keyboardDismissMode: @string
      [
        | @as("on-drag") #onDrag
        | #none
      ]=?,
      ~minSwipeDistance: float=?,
      ~overlayColor: string=?,
      ~statusBarAnimation: [#slide | #none | #fade]=?,
      ~_lazy: //TODO: ~gestureHandlerProps: React.ComponentProps<typeof PanGestureHandler>;
      bool=?,
      ~unmountInactiveRoutes: bool=?,
      ~drawerContent: React.component<contentComponentProps>=?,
      ~drawerContentOptions: contentOptions=?,
      ~sceneContainerStyle: ReactNative.Style.t=?,
      ~style: ReactNative.Style.t=?,
      ~key: string=?,
      unit,
    ) => navigatorProps = ""

    let make = stack["Navigator"]
  }
}
