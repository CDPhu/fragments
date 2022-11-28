const { Fragment } = require('../../model/fragment');
const { createSuccessResponse, createErrorResponse } = require('../../response');
const logger = require('../../logger');
require('dotenv').config();
const contentType = require('content-type');

module.exports = async (req, res) => {
  // TODO: this is just a placeholder to get something working...
  let fragment;
  const api = process.env.API_URL;
  if (Buffer.isBuffer(req.body) === true) {
    fragment = new Fragment({
      ownerId: req.user,
      type: req.get('Content-Type'),
      size: req.body.length,
    });
    try {
      await fragment.save();
      await fragment.setData(req.body);
      res.location(`${api}/v1/fragments/${fragment.id}`);
      res.status(201).json(createSuccessResponse({ fragment }));
      logger.info({ fragment: fragment }, `successfully posted fragment`);
    } catch (err) {
      logger.error(`${contentType.parse(req).type} is not supported`);
      res.status(415).json(415, 'unable to post fragment ' + fragment.type);
    }
  } else {
    res.status(415).json(createErrorResponse(415, 'not supported type'));
    logger.info(`posting fragment was unsuccessful`);
  }
};
