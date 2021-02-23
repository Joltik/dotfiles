/**
 * @format
 */

import React, {Component} from 'react';
import {AppRegistry} from 'react-native';
import App from './App';
import {name as appName} from './app.json';
import 'react-native-gesture-handler';

AppRegistry.registerComponent(appName, function () {
	return class extends Component {
		render() {
			return <App AdHocSigned={this.props.AdHocSigned} />;
		}
	};
});

