// @ts-expect-error
import { Deezer } from '@vaultalexandria/deezer-js'
import { ApiHandler } from '../../../types'
import { sessionDZ } from '../../../app'
import { logger } from '../../../helpers/logger'

const path: ApiHandler['path'] = '/retryDownload'

const handler: ApiHandler['handler'] = async (req, res) => {
	if (!sessionDZ[req.session.id]) sessionDZ[req.session.id] = new Deezer()
	const deemix = req.app.get('deemix')

	let response: any
	try {
		response = await deemix.RestartDownload(req.body.uuid, req.session.id)
	} catch (e) {
		logger.error(e)
		res.send({ result: false, errid: 'InternalError', data: { error: e.message } })
		return
	}
	res.send(response)
}

const apiHandler: ApiHandler = { path, handler }

export default apiHandler
