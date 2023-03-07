"use strict";

var _interopRequireDefault = require("@babel/runtime/helpers/interopRequireDefault");

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.serializePathv1 = serializePathv1;
exports.signSendChunkv1 = signSendChunkv1;

var _regenerator = _interopRequireDefault(require("@babel/runtime/regenerator"));

var _asyncToGenerator2 = _interopRequireDefault(require("@babel/runtime/helpers/asyncToGenerator"));

var _common = require("./common");

var HARDENED = 0x80000000;

function serializePathv1(path) {
  if (typeof path !== "string") {
    throw new Error("Path should be a string (e.g \"m/44'/461'/5'/0/3\")");
  }

  if (!path.startsWith("m")) {
    throw new Error('Path should start with "m" (e.g "m/44\'/461\'/5\'/0/3")');
  }

  var pathArray = path.split("/");

  if (pathArray.length !== 6) {
    throw new Error("Invalid path. (e.g \"m/44'/461'/5'/0/3\")");
  }

  var buf = Buffer.alloc(20);

  for (var i = 1; i < pathArray.length; i += 1) {
    var value = 0;
    var child = pathArray[i];

    if (child.endsWith("'")) {
      value += HARDENED;
      child = child.slice(0, -1);
    }

    var childNumber = Number(child);

    if (Number.isNaN(childNumber)) {
      throw new Error("Invalid path : ".concat(child, " is not a number. (e.g \"m/44'/461'/5'/0/3\")"));
    }

    if (childNumber >= HARDENED) {
      throw new Error("Incorrect child value (bigger or equal to 0x80000000)");
    }

    value += childNumber;
    buf.writeUInt32LE(value, 4 * (i - 1));
  }

  return buf;
}

function signSendChunkv1(_x, _x2, _x3, _x4) {
  return _signSendChunkv.apply(this, arguments);
}

function _signSendChunkv() {
  _signSendChunkv = (0, _asyncToGenerator2.default)( /*#__PURE__*/_regenerator.default.mark(function _callee(app, chunkIdx, chunkNum, chunk) {
    var payloadType;
    return _regenerator.default.wrap(function _callee$(_context) {
      while (1) {
        switch (_context.prev = _context.next) {
          case 0:
            payloadType = _common.PAYLOAD_TYPE.ADD;

            if (chunkIdx === 1) {
              payloadType = _common.PAYLOAD_TYPE.INIT;
            }

            if (chunkIdx === chunkNum) {
              payloadType = _common.PAYLOAD_TYPE.LAST;
            }

            return _context.abrupt("return", app.transport.send(_common.CLA, _common.INS.SIGN_SECP256K1, payloadType, 0, chunk, [0x9000, 0x6984, 0x6a80]).then(function (response) {
              var errorCodeData = response.slice(-2);
              var returnCode = errorCodeData[0] * 256 + errorCodeData[1];
              var errorMessage = (0, _common.errorCodeToString)(returnCode);

              if (returnCode === 0x6a80 || returnCode === 0x6984) {
                errorMessage = "".concat(errorMessage, " : ").concat(response.slice(0, response.length - 2).toString("ascii"));
              }

              var signatureCompact = null;
              var signatureDER = null;

              if (response.length > 2) {
                signatureCompact = response.slice(0, 65);
                signatureDER = response.slice(65, response.length - 2);
              }

              return {
                signature_compact: signatureCompact,
                signature_der: signatureDER,
                return_code: returnCode,
                error_message: errorMessage
              };
            }, _common.processErrorResponse));

          case 4:
          case "end":
            return _context.stop();
        }
      }
    }, _callee);
  }));
  return _signSendChunkv.apply(this, arguments);
}