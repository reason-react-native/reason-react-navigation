open Core

type options

type safeAreaInsets = {
  top: float,
  bottom: float,
  left: float,
  right: float,
}

type layout = {
  width: float,
  height: float,
}

type layouts = {
  screen: layout,
  title: option<layout>,
  leftLabel: option<layout>,
}

//TODO
type any
type animatedNode = ReactNative.Animated.Value.t
type stackHeaderInterpolation = {progress: animatedNode}
type stackHeaderInterpolationProps = {
  current: stackHeaderInterpolation,
  next: option<stackHeaderInterpolation>,
  layouts: layouts,
}
type stackHeaderInterpolatedStyle = {
  leftLabelStyle: option<any>,
  leftButtonStyle: option<any>,
  rightButtonStyle: option<any>,
  titleStyle: option<any>,
  backgroundStyle: option<any>,
}
type stackHeaderStyleInterpolator = stackHeaderInterpolationProps => stackHeaderInterpolatedStyle

type insets = {
  top: float,
  right: float,
  bottom: float,
  left: float,
}

type stackCardInterpolationProps = {
  current: stackHeaderInterpolation,
  next: option<stackHeaderInterpolation>,
  index: int,
  closing: animatedNode,
  layouts: layouts,
  insets: insets,
}
type stackCardInterpolatedStyle = {
  containerStyle: option<any>,
  cardStyle: option<any>,
  overlayStyle: option<any>,
  shadowStyle: option<any>,
}
type stackCardStyleInterpolator = stackCardInterpolationProps => stackCardInterpolatedStyle

type layoutChangeEvent

type backImageProps = {tintColor: ReactNative.Color.t}
type backImage = backImageProps => React.element
type stackHeaderLeftButtonProps = {
  disabled: option<bool>,
  onPress: option<unit => unit>,
  pressColorAndroid: option<ReactNative.Color.t>,
  backImage: option<backImage>,
  tintColor: option<ReactNative.Color.t>,
  label: option<string>,
  truncatedLabel: option<string>,
  labelVisible: option<bool>,
  labelStyle: option<ReactNative.Style.t>,
  allowFontScaling: option<bool>,
  onLabelLayout: option<layoutChangeEvent => unit>,
  screenLayout: option<layout>,
  titleLayout: option<layout>,
  canGoBack: option<bool>,
}

module TransitionSpec = {
  type t
  type springConfig = {
    damping: int,
    mass: int,
    stiffness: int,
    restSpeedThreshold: int,
    restDisplacementThreshold: int,
    overshootClamping: bool,
  }
  @obj
  external spring: (~animation: [#spring], ~config: springConfig) => t = ""

  type timingConfig = {
    duration: int,
    easing: ReactNative.Easing.t,
  }

  @obj
  external timing: (~animation: [#timing], ~config: timingConfig) => t = ""
}

type transitionSpec = {
  @as("open")
  open_: TransitionSpec.t,
  close: TransitionSpec.t,
}

module StackNavigationScreenProp = (
  M: {
    type params
    type options
  },
) => {
  include NavigationScreenProp(M)

  type t = navigation

  @send external push: (t, string) => unit = "push"
  @send external pushWithParams: (t, string, M.params) => unit = "push"

  @send external pop: (t, ~count: int=?, unit) => unit = "pop"

  @send external popToTop: (t, unit) => unit = "popToTop"
}

module Make = (
  M: {
    type params
  },
) => {
  type route = route<M.params>
  module Navigation = StackNavigationScreenProp({
    include M
    type options = options
  })

  type gestureResponseDistance
  @obj
  external gestureResponseDistance: (
    ~vertical: float=?,
    ~horizontal: float=?,
    unit,
  ) => gestureResponseDistance = ""

  module HeaderTitle = {
    type t

    type headerTitleProps = {
      onLayout: layoutChangeEvent => unit,
      allowFontScaling: option<bool>,
      style: option<ReactNative.Style.t>, //textStyle
      children: option<string>,
    }

    @val @module("./Interop")
    external t: @unwrap
    [
      | #String(string)
      | #Render(headerTitleProps => React.element)
    ] => t = "identity"

    let string = s => t(#String(s))
    let render = x => t(#Render(x))
  }

  type mode = string //TODO: [ | `float | `screen | `none]

  module Header = {
    type descriptor = {
      render: unit => React.element,
      options: options,
      navigation: navigation,
    }
    type progress = {
      current: animatedNode,
      next: option<animatedNode>,
      previous: option<animatedNode>,
    }
    type rec headerProps<'params> = {
      mode: mode,
      style: ReactNative.Style.t,
      /* extends NavigationSceneRendererProps */
      layout: layout,
      scene: scene<Core.route<'params>>,
      previous: option<scene<Core.route<'params>>>,
      navigation: navigation,
      styleInterpolator: stackHeaderStyleInterpolator,
    }
    and scene<'t> = {
      route: 't,
      descriptor: descriptor,
      progress: progress,
    }

    type t
    @val @module("./Interop")
    external t: @unwrap
    [
      | #Render(headerProps<'params> => React.element)
      | #Null(Js.null<unit>)
    ] => t = "identity"

    let render = x => t(#Render(x))

    let null = t(#Null(Js.Null.empty))
  }

  type headerRightOptions = {tintColor: option<ReactNative.Color.t>}
  type headerBackgroundOptions = {style: option<ReactNative.Style.t>}

  @obj
  external options: (
    ~animationEnabled: bool=?,
    ~animationTypeForReplace: [#push | #pop]=?,
    ~cardOverlay: unit => React.element=?,
    ~cardOverlayEnabled: bool=?,
    ~cardShadowEnabled: bool=?,
    ~cardStyle: ReactNative.Style.t=?,
    ~cardStyleInterpolator: stackCardStyleInterpolator=?,
    ~detachPreviousScreen: bool=?,
    ~gestureDirection: [#horizontal | #vertical]=?,
    ~gestureEnabled: bool=?,
    ~gestureResponseDistance: gestureResponseDistance=?,
    ~gestureVelocityImpact: float=?,
    ~header: Header.t=?,
    ~headerBackAccessibilityLabel: string=?,
    ~headerBackAllowFontScaling: bool=?,
    ~headerBackground: headerBackgroundOptions => React.element=?,
    ~headerBackImage: backImage=?,
    ~headerBackTitle: string=?,
    ~headerBackTitleStyle: ReactNative.Style.t=?,
    ~headerBackTitleVisible: bool=?,
    ~headerLeft: stackHeaderLeftButtonProps => React.element=?,
    ~headerLeftContainerStyle: ReactNative.Style.t=?,
    ~headerPressColorAndroid: ReactNative.Color.t=?,
    ~headerRight: headerRightOptions => React.element=?,
    ~headerRightContainerStyle: ReactNative.Style.t=?,
    ~headerShown: bool=?,
    ~headerStatusBarHeight: ReactNative.Style.size=?,
    ~headerStyle: ReactNative.Style.t=?,
    ~headerStyleInterpolator: stackHeaderStyleInterpolator=?,
    ~headerTintColor: ReactNative.Color.t=?,
    ~headerTitle: HeaderTitle.t=?,
    ~headerTitleAlign: [#left | #center]=?,
    ~headerTitleAllowFontScaling: bool=?,
    ~headerTitleContainerStyle: ReactNative.Style.t=?,
    ~headerTitleStyle: ReactNative.Style.t=?,
    ~headerTransparent: bool=?,
    ~headerTruncatedBackTitle: string=?,
    ~safeAreaInsets: safeAreaInsets=?,
    ~title: string=?,
    ~transitionSpec: transitionSpec=?,
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
    mode: option<string>,
    headerMode: option<string>,
    keyboardHandlingEnabled: option<bool>,
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

  @module("@react-navigation/stack")
  external make: unit => {
    "Navigator": navigatorProps => React.element,
    "Screen": screenProps<M.params> => React.element,
  } = "createStackNavigator"

  let stack = make()
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
    let make = stack["Screen"]
  }
  module Screen = {
    type componentProps = {navigation: navigation}
    @obj
    external makeProps: (
      ~name: string,
      ~options: optionsCallback=?,
      ~initialParams: M.params=?,
      ~component: React.component<{"navigation": navigation, "route": route}>,
      ~key: string=?,
      unit,
    ) => screenProps<M.params> = ""

    let make = stack["Screen"]
  }

  module Navigator = {
    @obj
    external makeProps: (
      ~initialRouteName: string=?,
      ~screenOptions: optionsCallback=?,
      ~mode: [#card | #modal]=?,
      ~headerMode: [#float | #screen | #none]=?,
      ~keyboardHandlingEnabled: bool=?,
      ~children: React.element,
      ~key: string=?,
      unit,
    ) => navigatorProps = ""

    let make = stack["Navigator"]
  }
}

module TransitionSpecs = {
  /* Exact values from UINavigationController's animation configuration */
  @module("@react-navigation/stack") @scope("TransitionSpecs")
  external transitionIOSSpec: transitionSpec = "TransitionIOSSpec"
  /* Configuration for activity open animation from Android Nougat */
  @module("@react-navigation/stack") @scope("TransitionSpecs")
  external fadeInFromBottomAndroidSpec: transitionSpec = "FadeInFromBottomAndroidSpec"
  /* Configuration for activity close animation from Android Nougat */
  @module("@react-navigation/stack") @scope("TransitionSpecs")
  external fadeOutToBottomAndroidSpec: transitionSpec = "FadeOutToBottomAndroidSpec"
  /* Approximate configuration for activity open animation from Android Pie */
  @module("@react-navigation/stack") @scope("TransitionSpecs")
  external revealFromBottomAndroidSpec: transitionSpec = "RevealFromBottomAndroidSpec"
}

module CardStyleInterpolators = {
  /* Standard iOS-style slide in from the right */
  @module("@react-navigation/stack") @scope("CardStyleInterpolators")
  external forHorizontalIOS: stackCardStyleInterpolator = "forHorizontalIOS"
  /* Standard iOS-style slide in from the bottom (used for modals) */
  @module("@react-navigation/stack") @scope("CardStyleInterpolators")
  external forVerticalIOS: stackCardStyleInterpolator = "forVerticalIOS"
  /* Standard iOS-style modal animation in iOS 13 */
  @module("@react-navigation/stack") @scope("CardStyleInterpolators")
  external forModalPresentationIOS: stackCardStyleInterpolator = "forModalPresentationIOS"
  /* Standard Android-style fade in from the bottom for Android Oreo */
  @module("@react-navigation/stack") @scope("CardStyleInterpolators")
  external forFadeFromBottomAndroid: stackCardStyleInterpolator = "forFadeFromBottomAndroid"
  /* Standard Android-style reveal from the bottom for Android Pie */
  @module("@react-navigation/stack") @scope("CardStyleInterpolators")
  external forRevealFromBottomAndroid: stackCardStyleInterpolator = "forRevealFromBottomAndroid"
}

module HeaderStyleInterpolators = {
  /* Standard UIKit style animation for the header where the title fades into the back button label */
  @module("@react-navigation/stack") @scope("HeaderStyleInterpolators")
  external forUIKit: stackHeaderStyleInterpolator = "forUIKit"
  /* Simple fade animation for the header elements */
  @module("@react-navigation/stack") @scope("HeaderStyleInterpolators")
  external forFade: stackHeaderStyleInterpolator = "forFade"
  /* Simple translate animation to translate the header along with the sliding screen */
  @module("@react-navigation/stack") @scope("HeaderStyleInterpolators")
  external forStatic: stackHeaderStyleInterpolator = "forStatic"
}

module TransitionPresets = {
  /* Standard iOS navigation transition. */
  @module("@react-navigation/stack") @scope("TransitionPresets")
  external slideFromRightIOS: options = "SlideFromRightIOS"

  /* Standard iOS navigation transition for modals. */
  @module("@react-navigation/stack") @scope("TransitionPresets")
  external modalSlideFromBottomIOS: options = "ModalSlideFromBottomIOS"

  /* Standard iOS modal presentation style (introduced in iOS 13). */
  @module("@react-navigation/stack") @scope("TransitionPresets")
  external modalPresentationIOS: options = "ModalPresentationIOS"

  /* Standard Android navigation transition when opening or closing an Activity on Android < 9 (Oreo). */
  @module("@react-navigation/stack") @scope("TransitionPresets")
  external fadeFromBottomAndroid: options = "FadeFromBottomAndroid"

  /* Standard Android navigation transition when opening or closing an Activity on Android >= 9 (Pie). */
  @module("@react-navigation/stack") @scope("TransitionPresets")
  external revealFromBottomAndroid: options = "RevealFromBottomAndroid"

  /* Standard Android navigation transition when opening or closing an Activity on Android >= 10 */
  @module("@react-navigation/stack") @scope("TransitionPresets")
  external scaleFromCenterAndroid: options = "ScaleFromCenterAndroid"

  /* Default navigation transition for the current platform. */
  @module("@react-navigation/stack") @scope("TransitionPresets")
  external defaultTransition: options = "DefaultTransition"

  /* Default modal transition for the current platform. */
  @module("@react-navigation/stack") @scope("TransitionPresets")
  external modalTransition: options = "ModalTransition"
}

@val
external mergeOptions: (options, options) => options = "Object.assign"
