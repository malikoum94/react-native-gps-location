import {NativeModules, NativeEventEmitter} from 'react-native'

const {RNGpsLocation} = NativeModules
const RNGpsLocationEmitter = new NativeEventEmitter(RNGpsLocation)
class GpsLocation {
  constructor() {
    this.errorListener = null
    this.locationListener = null
    this.enterListener = null
    this.exitListener = null
    this.visitListener = null
    this.askAlwaysAuthorization = () => RNGpsLocation.askAlwaysAuthorization()
    this.askInUseAuthorization = () => RNGpsLocation.askInUseAuthorization()
    this.getAuthorization = () => RNGpsLocation.getAuthorization()
    this.getLocation = () => RNGpsLocation.getLocation()
    this.startMonitor = (latitude, longitude, name) =>
      RNGpsLocation.startMonitor(latitude, longitude, name)
    this.stopMonitor = () => RNGpsLocation.stopMonitor()
    this.allowBackgroundLocation = (distance, timeout) =>
      RNGpsLocation.allowBackgroundLocation(distance, timeout)
    this.disallowBackgroundLocation = () =>
      RNGpsLocation.disallowBackgroundLocation()
    this.updateLocation = () => RNGpsLocation.updateLocation()
    this.stopUpdateLocation = () => RNGpsLocation.stopUpdateLocation()
    this.startVisit = () => RNGpsLocation.startVisit()
    this.stopVisit = () => RNGpsLocation.stopVisit()
    this.getErrorListener = cb =>
      (this.errorListener = RNGpsLocationEmitter.addListener('error', cb))
    this.getLocationListener = cb =>
      (this.locationListener = RNGpsLocationEmitter.addListener('location', cb))
    this.getEnterListener = cb =>
      (this.enterListener = RNGpsLocationEmitter.addListener('enter', cb))
    this.getExitListener = cb =>
      (this.exitListener = RNGpsLocationEmitter.addListener('exit', cb))
    this.getVisitListener = cb =>
      (this.visitListener = RNGpsLocationEmitter.addListener('visit', cb))
    this.removeError = () => this.errorListener && this.errorListener.remove()
    this.removeLocation = () =>
      this.locationListener && this.locationListener.remove()
    this.removeEnter = () => this.enterListener && this.enterListener.remove()
    this.removeExit = () => this.exitListener && this.exitListener.remove()
    this.removeVisit = () => this.visitListener && this.visitListener.remove()
  }
}

export default new GpsLocation()
