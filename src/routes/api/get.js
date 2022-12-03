const { createSuccessResponse, createErrorResponse } = require('../../response');
const { Fragment } = require('../../model/fragment');
const logger = require('../../logger');

// src/routes/api/get.js

/**
 * Get a list of fragments for the current user
 */
let fragment;
module.exports = {
  get: async (req, res) => {
    if (req.user) {
      if (req.query) {
        try {
          fragment = await Fragment.byUser(req.user, req.query.expand);
        } catch (err) {
          res.status(404).json(createErrorResponse(404, 'no such user'));
        }
        res.status(200).json(createSuccessResponse({ fragments: fragment }));
        logger.info({ fragmentList: fragment }, `successfully get fragment list`);
      }
    }
  },
};
