import React from 'react';
import {Text, View, ScrollView, TouchableWithoutFeedback} from 'react-native';
import AutoSizeImage from '../../components/AutoSizeImage';
import Images from '../../common/images';

const itemSpace = 6;
const titleSpace = 12;
const poiSize = 22;
const textLineHeight = 22;
const brHeight = 20;

const ShowInfo = (props) => {
	const value = props.info;
	const renderTitleItem = (item, index) => {
		return (
			<View
				key={index}
				style={{
					marginVertical: titleSpace,
				}}>
				<Text style={{fontSize: 16, color: '#333333', fontWeight: 'bold'}}>
					{item.value}
				</Text>
			</View>
		);
	};

	const renderTextItem = (item, isStrong, index) => {
		return (
			<View
				key={index}
				style={{
					marginVertical: itemSpace,
				}}>
				<Text
					style={{
						fontSize: 14,
						color: '#333333',
						lineHeight: textLineHeight,
						fontWeight: isStrong ? 'bold' : 'normal',
					}}>
					{`	${item.value}`}
				</Text>
			</View>
		);
	};

	const renderOnePoiItem = (item, index) => {
		const {value, sort} = item;
		return (
			<View key={index} style={{flexDirection: 'row', marginTop: 5}}>
				<View
					style={{
						height: '100%',
						alignItems: 'center',
						paddingRight: itemSpace,
					}}>
					<View
						style={{
							marginTop: itemSpace,
							borderRadius: 15,
							overflow: 'hidden',
						}}>
						<Text
							style={{
								fontSize: 14,
								color: '#333333',
								width: poiSize,
								height: poiSize,
								backgroundColor: '#fff000',
								textAlign: 'center',
								lineHeight: poiSize,
							}}>
							{sort ? sort : index + 1}
						</Text>
					</View>
				</View>
				<View
					key={index}
					style={{
						flex: 1,
						flexDirection: 'row',
						flexWrap: 'wrap',
						marginVertical: itemSpace,
					}}>
					<Text
						style={{
							fontSize: 14,
							color: '#333333',
							lineHeight: textLineHeight,
						}}>
						{value}
					</Text>
				</View>
			</View>
		);
	};

	const renderPoiItem = (item, index) => {
		let pois = [];
		for (let i = 0; i < item.value.length; i++) {
			pois.push(renderOnePoiItem(item.value[i], i));
		}
		return (
			<View key={index} style={{}}>
				{pois}
			</View>
		);
	};

	const renderImgItem = (item, index) => {
		const {value} = item;
		return (
			<AutoSizeImage
				key={index}
				style={{height: 100, backgroundColor: 'red'}}
				uri={Images.showInfo[value]}
			/>
		);
	};

	let items = [];
	value.forEach((item, index) => {
		const {key} = item;
		if (key == 'h1') {
			items.push(renderTitleItem(item, index));
		} else if (key == 'text') {
			items.push(renderTextItem(item, false, index));
		} else if (key == 'strong') {
			items.push(renderTextItem(item, true, index));
		} else if (key == 'poi') {
			items.push(renderPoiItem(item, index));
		} else if (key == 'br') {
			items.push(<View style={{height: brHeight}} key={index} />);
		} else if (key == 'img') {
			items.push(renderImgItem(item, index));
		}
	});

	return (
		<ScrollView showsVerticalScrollIndicator={false}>
			<View style={{padding: 10}}>{items}</View>
		</ScrollView>
	);
};

export default ShowInfo;

