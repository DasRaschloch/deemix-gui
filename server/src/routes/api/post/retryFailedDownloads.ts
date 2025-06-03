// @ts-expect-error
import { Deezer } from '@vaultalexandria/deezer-js'
import { ApiHandler } from '../../../types'
import { sessionDZ } from '../../../app'
import { logger } from '../../../helpers/logger'

const path: ApiHandler['path'] = '/retryFailedDownloads'

const handler: ApiHandler['handler'] = async (req, res) => {
	if (!sessionDZ[req.session.id]) sessionDZ[req.session.id] = new Deezer()
	const deemix = req.app.get('deemix')

	let responses: any[] = []

	try {
		responses = await deemix.RestartAllErrors(req.session.id, responses)
	} catch (e) {
		logger.error(e)
		return res.send({ result: false, errid: 'InternalError', data: { error: e.message } })
	}

	res.send({ result: true, data: responses })
}

const apiHandler: ApiHandler = { path, handler }

export default apiHandler
