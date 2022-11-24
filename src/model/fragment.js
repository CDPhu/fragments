const { uuid } = require('uuidv4');
// Use https://www.npmjs.com/package/content-type to create/parse Content-Type headers
const contentType = require('content-type');

const logger = require('../logger');

// Functions for working with fragment metadata/data using our DB
const {
  readFragment,
  writeFragment,
  readFragmentData,
  writeFragmentData,
  listFragments,
  deleteFragment,
} = require('./data');
// eslint-disable-next-line no-unused-vars
const { text } = require('express');

const validTypes = [
  'text/plain',
  'text/markdown',
  'text/html',
  'application/json',
  // `image/png`,
  // `image/jpeg`,
  // `image/webp`,
  // `image/gif`,
];

class Fragment {
  // eslint-disable-next-line no-unused-vars
  constructor({ id, ownerId, created, updated, type, size = 0 }) {
    if (!ownerId) {
      throw new Error('Owner ID is mandatory');
    } else if (!type) {
      throw new Error('Type is mandatory');
    } else if (typeof size !== 'number') {
      throw new Error('Size must be a number');
    } else if (size < 0) {
      throw new Error('Size must be a positive number');
    } else if (!validTypes.some((item) => type.includes(item))) {
      throw new Error(`${type} is not supported`);
    } else {
      // create a new id if id is not passed
      this.id = id ? id : uuid();
      this.ownerId = ownerId;
      this.created = created ? created : new Date().toISOString();
      this.updated = updated ? updated : new Date().toISOString();
      this.type = type;
      this.size = size;
    }
  }

  /**
   * Get all fragments (id or full) for the given user
   * @param {string} ownerId user's hashed email
   * @param {boolean} expand whether to expand ids to full fragments
   * @returns Promise<Array<Fragment>>
   */
  static async byUser(ownerId, expand = false) {
    // return await listFragments(ownerId, expand);
    try {
      logger.debug({ ownerId, expand }, 'Fragment.byUser()');
      const fragments = await listFragments(ownerId, expand);
      return expand ? fragments.map((fragment) => new Fragment(fragment)) : fragments;
    } catch (err) {
      // A user might not have any fragments (yet), so return an empty
      // list instead of an error when there aren't any.
      return [];
    }
  }

  /**
   * Gets a fragment for the user by the given id.
   * @param {string} ownerId user's hashed email
   * @param {string} id fragment's id
   * @returns Promise<Fragment>
   */
  static async byId(ownerId, id) {
    try {
      logger.debug(`Fragment data with id: ${id} from owner: ${ownerId}`);
      const frag = await readFragment(ownerId, id);
      if (!frag) {
        logger.warn('No fragment found with the provided data');
        throw new Error('No fragment found with the provided data');
      }
      return frag;
    } catch (err) {
      throw new Error(err);
    }
  }

  /**
   * Delete the user's fragment data and metadata for the given id
   * @param {string} ownerId user's hashed email
   * @param {string} id fragment's id
   * @returns Promise
   */
  static delete(ownerId, id) {
    return deleteFragment(ownerId, id);
  }

  /**
   * Saves the current fragment to the database
   * @returns Promise
   */
  save() {
    logger.info(`Saving fragment to database`);
    logger.debug(`Fragment being saved: ${this}`);
    this.updated = new Date().toISOString();
    return writeFragment(this);
  }

  /**
   * Gets the fragment's data from the database
   * @returns Promise<Buffer>
   */
  getData() {
    return readFragmentData(this.ownerId, this.id);
  }

  /**
   * Set's the fragment's data in the database
   * @param {Buffer} data
   * @returns Promise
   */
  async setData(data) {
    if (!Buffer.isBuffer(data)) {
      logger.debug(`Type of data is:  ${typeof data}`);
      throw new Error('data is not a buffer. Check log for details');
    }
    logger.debug(`Setting data for this fragment`);
    this.updated = new Date().toISOString();
    this.size = Buffer.byteLength(data);
    return writeFragmentData(this.ownerId, this.id, data);
  }

  /**
   * Returns the mime type (e.g., without encoding) for the fragment's type:
   * "text/html; charset=utf-8" -> "text/html"
   * @returns {string} fragment's mime type (without encoding)
   */
  get mimeType() {
    const { type } = contentType.parse(this.type);
    return type;
  }

  /**
   * Returns true if this fragment is a text/* mime type
   * @returns {boolean} true if fragment's type is text/*
   */
  get isText() {
    return this.mimeType.startsWith('text/');
  }

  /**
   * Returns the formats into which this fragment type can be converted
   * @returns {Array<string>} list of supported mime types
   */
  get formats() {
    const type = this.mimeType;
    switch (type) {
      case 'text/markdown':
        return ['text/markdown', 'text/html', 'text/plain'];

      case 'text/plain':
        return ['text/plain'];

      case 'text/html':
        return ['text/html', 'text/plain'];

      case 'application/json':
        return ['application/json', 'text/plain'];

      default:
        logger.info(`${this.mimeType} file type is not supported`);
        return [];
    }
  }

  /**
   * Returns true if we know how to work with this content type
   * @param {string} value a Content-Type value (e.g., 'text/plain' or 'text/plain: charset=utf-8')
   * @returns {boolean} true if we support this Content-Type (i.e., type/subtype)
   */
  static isSupportedType(value) {
    // accepts all text types and json. Check validTypes for the full list
    return validTypes.some((item) => value.includes(item));
  }
}

module.exports.Fragment = Fragment;
