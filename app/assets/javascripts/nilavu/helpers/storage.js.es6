import {encode} from 'nilavu/helpers/webtoolkit-base64';
import {b64_hmac_sha1} from 'nilavu/helpers/sha1';
export function generateSignature(obj) {
    const policy_sign = {
        "expiration": "2016-07-02T12:00:00.000Z",
        "conditions": [{
                "bucket": obj.bucketName
            }, {
                "acl": obj.acl
            },
            ["eq", "$key", obj.name],
            ["starts-with", "$Content-Type", "text/"],
        ]
    };
    var policy = encode(JSON.stringify(policy_sign))
    var signature = b64_hmac_sha1(obj.secret_access_key, policy);
    return {"policy": policy, "signature": signature};
}
