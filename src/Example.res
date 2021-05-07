// Uncomment this to compile this example outside of this repo
// in this example it's not necessary (since we are running it in the module repo itself)
// open ReactNavigation;
module HomeScreen = {
  open ReactNative
  @react.component
  let make = (~navigation as _, ~route as _) =>
    <Text> {j`Hello Reasonable Person!`->React.string} </Text>
}

module ModalScreen = {
  open ReactNative
  @react.component
  let make = (~navigation as _, ~route as _) => <Text> {j`Hello From Modal`->React.string} </Text>
}

module MainStackScreen = {
  open ReactNative
  module StakeParams = {
    type params = {name: string}
  }
  include Stack.Make(StakeParams)
  @react.component
  let make = (~navigation as _, ~route as _) =>
    <Navigator>
      <Screen
        name="Home"
        component=HomeScreen.make
        options={props =>
          options(
            ~headerRight=_ =>
              <Button
                onPress={_ => props.navigation->Navigation.navigate("MyModal")}
                title="Info"
                color="#f00"
              />,
            ~title=switch props.route.params {
            | Some(params) => params.name
            | None => "Reason"
            },
            (),
          )}
      />
    </Navigator>
}

module RootStackScreen = {
  include Stack.Make({
    type params = unit
  })
  @react.component
  let make = () =>
    <Native.NavigationContainer>
      <Navigator mode=#modal headerMode=#none>
        <Screen name="Main" component=MainStackScreen.make />
        <ScreenWithCallback name="MyModal">
          {({navigation, route}) => <ModalScreen navigation route />}
        </ScreenWithCallback>
      </Navigator>
    </Native.NavigationContainer>
}
