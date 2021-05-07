/*
 # Example with state persistance

 Require to have
 - @reason-react-native/storage (ReactNativeAsyncStorage)
 - reason-future

 Require to define your own

 - <RootNavigator />
 - <BootSplash />


 ```reason
 open Belt;
 open ReactNative;

 // @todo
 // <RootNavigator />
 // <Bootsplash />

 type navigationState;
 let navigationStateStorageKey = "react-navigation:state";

 [@react.component]
 let app = () => {
   let (initialStateContainer, setInitialState) = React.useState(() => None);

   React.useEffect1(
     () => {
       if (initialStateContainer->Option.isNone) {
         ReactNativeAsyncStorage.getItem(navigationStateStorageKey)
         ->FutureJs.fromPromise(error => {
             // @todo ?
             Js.log2("Restoring Navigation State: ", error);
             error;
           })
         ->Future.tap(res => {
             switch (res) {
             | Result.Ok(jsonState) =>
               switch (jsonState->Js.Null.toOption) {
               | Some(jsonState) =>
                 switch (Js.Json.parseExn(jsonState)) {
                 | state =>
                   setInitialState(_ => Some(Some(state)));
                 | exception _ =>
                   Js.log2(
                     "Restoring Navigation State: unable to decode valid json",
                     jsonState,
                   );
                   setInitialState(_ => Some(None));
                 }
               | None => setInitialState(_ => Some(None))
               };
             | Result.Error(e) =>
               Js.log2(
                 "Restoring Navigation State: unable to get json state",
                 e,
               );
               setInitialState(_ => Some(None));
             };
           })
         ->ignore;
       };
       None;
     },
     [|initialStateContainer|],
   );

   let isReady = initialStateContainer->Option.isSome;
   <>
       {initialStateContainer
        ->Option.map(initialState =>
            <Native.NavigationContainer
              ?initialState
              onStateChange={state => {
                let maybeJsonState = Js.Json.stringifyAny(state);
                switch (maybeJsonState) {
                | Some(jsonState) =>
                  AsyncStorage.setItem(navigationStateStorageKey, jsonState)
                  ->ignore
                | None => Js.log("Unable to stringify navigation state")
                };
              }}>
              <RootNavigator />
            </Native.NavigationContainer>
          )
        ->Option.getWithDefault(React.null)}
       <Bootsplash isReady />
   </>;
 };
 ```
 */

type themeColors = {
  primary: string,
  background: string,
  card: string,
  text: string,
  border: string,
  notification: string,
}
type theme = {
  dark: bool,
  colors: themeColors,
}
@module("@react-navigation/native")
external defaultTheme: theme = "DefaultTheme"
@module("@react-navigation/native")
external darkTheme: theme = "DarkTheme"
@module("@react-navigation/native")
external useTheme: unit => theme = "useTheme"

module NavigationContainer = {
  type state = Js.Json.t
  type navigationState = state => unit

  @module("@react-navigation/native") @react.component
  external make: (
    ~ref: ReactNative.Ref.t<Core.navigation>=?,
    ~initialState: state=?,
    ~onStateChange: navigationState=?,
    ~onReady: unit => unit=?,
    ~theme: theme=?,
    ~children: React.element,
  ) => React.element = "NavigationContainer"
}

@module("@react-navigation/native")
external useNavigation: unit => Js.nullable<Core.navigation> = "useNavigation"

@module("@react-navigation/native")
external useRoute: unit => Js.nullable<Core.route<'params>> = "useRoute"

@module("@react-navigation/native")
external useIsFocused: unit => bool = "useIsFocused"

type focusCallback = unit => unit
@module("@react-navigation/native")
external useFocusEffect: focusCallback => unit = "useFocusEffect"

@module("@react-navigation/native")
external useScrollToTop: React.ref<'value> => unit = "useScrollToTop"

type serverContainer<'a> = {getCurrentOptions: option<'a>}
type location = {
  pathname: string,
  search: string,
}
module ServerContainer = {
  @module("@react-navigation/native") @react.component
  external make: (
    ~ref: ReactNative.Ref.t<serverContainer<'a>>=?,
    ~location: location=?,
    ~children: React.element,
  ) => React.element = "ServerContainer"
}

@module("@react-navigation/native")
external useLinkTo: string => unit = "useLinkTo"

type linkPropsIn = {
  to_: string,
  action: unit => unit,
}
type linkPropsOut = {
  href: string,
  accessibilityRole: string,
  onPress: unit => unit,
}

@module("@react-navigation/native")
external useLinkProps: linkPropsIn => linkPropsOut = "useLinkProps"

type linkBuilderOut<'a> = (string, 'a) => string

@module("@react-navigation/native")
external useLinkBuilder: unit => linkBuilderOut<'a> = "useLinkBuilder"

module Link = {
  @module("@react-navigation/native") @react.component
  external make: (
    ~to_: string=?,
    ~action: unit => unit=?,
    ~children: React.element,
  ) => React.element = "Link"
}
